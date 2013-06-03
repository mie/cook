App = Ember.Application.create();

App.Store = DS.Store.extend({
  revision: 12,
  adapter:'DS.RESTAdapter'
});

App.Router.map(function() {
  this.resource("user", function() {
    this.route("page", { path: "/page/:page_id" });
  });
  //this.route("fourOhFour", { path: "*:"});
});

App.Auth = Ember.Auth.create({
  signInEndPoint: '/signin',
  signOutEndPoint: '/signout',
  tokenKey: 'auth_token',
  tokenIdKey: 'user_id',
  userModel: 'App.User',
  sessionAdapter: 'cookie',
  modules: [
    'emberData', 'rememberable'
  ],
  rememberable: {
    tokenKey: 'remember_token',
    period: 7,
    autoRecall: true
  }
});