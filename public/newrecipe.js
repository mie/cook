function NewRecipe(d){
  var div = d;
  var ing_data = [];
  var ing_uid = [];
  var ing_out = [];
  var that = this;

  function trim(value) {
    return value.replace(/^\s+|\s+$/g,"");
  }

  function getData(){
    $.ajax({
      dataType: 'json',
      success: function(data) {
        for(var i = 0; i < data.ingredients.length; i++){
          ing_data.push(data.ingredients[i]);
        }
      },
      error : function(jqXHR, textStatus, errorThrown) {
        alert("Error occurred: " + errorThrown);
      },
      url: '/ingredients.json'
    });
  }

  getData();

  this.checkElements = function(){
    if((ing_uid.length == 0) || (ing_uid.length > 0 && (trim($('#i' + ing_uid[ing_uid.length - 1]).val()) != '' && trim($('#q' + ing_uid[ing_uid.length - 1]).val()) != '') )){
      addElements();
    }
  }

  this.getIngredients = function(){
    return ing_out;
  }

  function addElements(){
    var uid = new Date().getTime().toString();
    ing_uid.push(uid);
    $('#ings').append($('<input>', {
      id: 'i'+uid,
      type: 'text',
    }).typeahead({source: ing_data}));
    $('#ings').append("<input id='q" + uid + "' class='quantity' type='text' /><input id='b" + uid + "' class='btn btn-large' type='button' value='OK' />");
    $('#b' + uid).bind('click', function(){
      if ( 'b' + uid == $(this).attr('id') ){
        var last_uid = ing_uid[ing_uid.length - 2];
        var ing_name = $('#i' + uid).val();
        var ing_quan = $('#q' + uid).val();
        ing_out.push({
          ingredient: $('#i' + uid).val(),
          quantity: $('#q' + uid).val()
        });
        $('#ingredients').append($('<div>', {class: 'well'}).append($('<h5>').text(ing_name).append($('<h6>').text(ing_quan))));
        that.checkElements();
      }
    });
  }
}