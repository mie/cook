App.UserController = Ember.ArrayController.extend(
  Ember.PaginationMixin, 
  {  
    itemsPerPage: 2
});