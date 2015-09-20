###
  Route Filters
  Filters for managing user access to application routes.
###

# Define Filters

###
  Filter: Check if a User is Logged In
  If a user is not logged in and attempts to go to an authenticated route,
  re-route them to the coming-soon screen.
###
checkUserLoggedIn = ->
  if not Meteor.loggingIn() and not Meteor.user()
    Router.go '/'
  else
    @next()

###
  Filter: Check if a Beta Tester User Exists
  If a user is logged in and attempts to go to a public route, re-route
  them to the main dashboard screen.
###
userAuthenticatedBetaTester = ->
  # Get the user and check against their role in the DB.
  loggedInUser = Meteor.user()
  isBetaTester = Roles.userIsInRole(loggedInUser, ['tester'])
  if not Meteor.loggingIn() and isBetaTester
    Router.go '/dashboard'
  else
    @next()

###
  Filter: Check if an Admin User Exists
  If a user is logged in and attempts to go to a public route, re-route
  them to the dashboard screen.
###
userAuthenticatedAdmin = ->
  # Get the user and check against their role in the DB.
  loggedInUser = Meteor.user()
  isAdmin      = Roles.userIsInRole(loggedInUser, ['admin'])
  if not Meteor.loggingIn() and isAdmin
    Router.go '/dashboard'
  else
    @next()

# Run Filters
Router.onBeforeAction checkUserLoggedIn, except: [
  'coming-soon',
  'signup',
  'signup/:token',
  'login',
  'recover-password',
  'reset-password'
]

# Beta tester disallow list
Router.onBeforeAction userAuthenticatedBetaTester, only: [
  'coming-soon',
  'signup',
  'signup/:token',
  'login',
  'recover-password',
  'reset-password',
  'invites'
]

# Admin disallow list
Router.onBeforeAction userAuthenticatedAdmin, only: [
  'coming-soon',
  'signup',
  'signup/:token',
  'login',
  'recover-password',
  'reset-password'
]
