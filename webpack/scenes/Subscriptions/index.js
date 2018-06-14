import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as subscriptionActions from './SubscriptionActions';

import * as taskActions from '../Tasks/TaskActions';
import * as settingActions from '../../move_to_foreman/Settings/SettingsActions';
import * as tableActions from '../Settings/Tables/TableActions';
import reducer from './SubscriptionReducer';
import { SUBSCRIPTION_TABLE_NAME } from './SubscriptionConstants';
import SubscriptionsPage from './SubscriptionsPage';

// map state to props
const mapStateToProps = (state) => {
  const subscriptionTableSettings = state.katello.settings.tables[SUBSCRIPTION_TABLE_NAME] || {};

  return {
    organization: state.katello.organization,
    subscriptions: state.katello.subscriptions,
    tasks: state.katello.subscriptions.tasks,
    subscriptionTableSettings,
  };
};

// map action dispatchers to props
const actions = {
  ...subscriptionActions,
  ...taskActions,
  ...settingActions,
  ...tableActions,
};
const mapDispatchToProps = dispatch => bindActionCreators(actions, dispatch);

// export reducers
export const subscriptions = reducer;

// export connected component
export default connect(mapStateToProps, mapDispatchToProps)(SubscriptionsPage);
