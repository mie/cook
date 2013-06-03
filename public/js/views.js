App.AuthView = Ember.View.extend({
  templateName: 'auth'
});

App.AuthSignInView = Ember.View.extend({
  templateName: 'sign-in',
  email: null,
  password: null,
  remember: true,
  submit: function(event, view){
    event.preventDefault();
    event.stopPropagation();
    console.log(this.get('email'));
    App.Auth.signIn({
      data:{
        email: this.get('email'),
        password: this.get('password'),
        remember: this.get('remember')
      }
    })
  }
});

App.AuthSignOutView = Ember.View.extend({
  templateName: 'sign-out',
  submit: function(event, view){
    event.preventDefault();
    event.stopPropagation();
    App.Auth.signOut();
  }
});

App.PaginationView = Ember.View.extend({
  templateName: 'pagination',
  tagName: 'li',
  page: function() {
    return Ember.Object.create({id: this.get('content.page_id')});
  }.property()
});