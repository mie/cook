// App.UsersRoute = Ember.Route.extend({
//   redirect: function() {
//     this.transitionTo('users.page');
//   }
// });

// App.UsersIndexRoute = Ember.Route.extend({
//   model: function(){
//     if (App.Auth.get('signedIn')){
//       App.User.find();
//     }
//   }
// });

// App.UsersShowRoute = Ember.Route.extend({
//   renderTemplate: 'show-user',
//   serialize: function(model){
//     {user_id: model.get('param')}
//   },
//   model: function(param){
//     if(App.Auth.get('signedIn')){
//       return App.User.find(param.user_id);
//     }
//   }
// });

App.UserPageRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.Object.create({id: params.page_id});
  },
  setupController: function(controller, model) {
    this.controllerFor('user').set('selectedPage', model.get('id'));
  }
});

App.UserRoute = Ember.Route.extend({
  model: function(params) {
    this.controllerFor('user').set('selectedPage', 1);
      return App.User.find({ page_number: this.controllerFor('user').get('currentPage') });
    }
});