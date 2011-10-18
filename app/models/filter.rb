#
# Copyright 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

class Filter < ActiveRecord::Base
  include Glue::Pulp::Filter if (AppConfig.use_cp and AppConfig.use_pulp)
  include Glue
  include Authorization

  validates :pulp_id, :presence => true
  validates_uniqueness_of :pulp_id, :scope => :organization_id, :message => N_("pulp_id must be unique within one organization")

  belongs_to :organization
  has_and_belongs_to_many :products, :uniq => true

  scoped_search :on => :name, :complete_value => true, :rename => :'filter.pulp_id'

  def self.list_tags org_id
    select('id,pulp_id').where(:organization_id=>org_id).collect { |m| VirtualTag.new(m.id, m.pulp_id) }
  end

  def self.tags(ids)
    select('id,pulp_id').where(:id => ids).collect { |m| VirtualTag.new(m.id, m.pulp_id) }
  end

  def self.list_verbs  global = false
    {
       :create => N_("Create Filter"),
       :read => N_("Access Filter"),
       :delete => N_("Delete Filter"),
    }.with_indifferent_access
  end

  def self.creatable? org
    User.allowed_to?([:create], :filters, nil, org)
  end

  def self.any_readable?(org)
    User.allowed_to?(READ_PERM_VERBS, :filters, nil, org)
  end

  def readable?
    User.allowed_to?(READ_PERM_VERBS, :filters, self.id, self.organization)
  end

  def deletable?
     User.allowed_to?([:delete, :create], :filters, self.id, self.organization)
  end

  READ_PERM_VERBS = [:read, :create, :delete]
end
