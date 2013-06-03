// -- Models --

App.User = DS.Model.extend({
  username: DS.attr('string'),
  realname: DS.attr('string'),
  email: DS.attr('string'),
  avatar: DS.attr('string'),
  param: DS.attr('string')
});
