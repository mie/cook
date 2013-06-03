 function Cook() {

  function trim(value) {
    return value.replace(/^\s+|\s+$/g,"");
  }

  function empty_fields(fields){
    var good = true;
    var bad_fields = [];
    for (var i = 0; i < fields.length; i++) {
      if(trim($('#'+fields[i]).val()) == ''){
        bad_fields.push(fields[i]);
      }
    }
    console.log(bad_fields);
    return bad_fields;
  }

  function merge_options(to, from){
    for (var attrname in from) {
      to[attrname] = from[attrname];
    }
    return to;
  };
  
  function model_url(model){
    var name = [model['name']] + 's' || '';
    var id = model['id'] || '';
    var words = ['', 'api'];
    if(name != ''){
      words.push(name);
    }
    if(id != ''){
      words.push(id);
    }
    return words.join('/');
  };

  function model_data(model){
    return JSON.stringify(model['data']);
  };

  this.signin = function(){
      if(empty_fields(['email', 'password']).length == 0){
        $.ajax({
          type: 'POST',
          contentType: 'application/json',
          url: '/api/signin',
          dataType: "json",
          //processData: false,
          data: model_data({data:{
            email: $('#email').val(),
            password: $('#password').val()
          }}),
          success: function(data, textStatus, jqXHR){
            window.location.replace("http://localhost:9393/");
          },
          error: function(jqXHR, textStatus, errorThrown){
            console.log(textStatus);
          }
        });
      } else {
        $('#alert').html("<div class='alert'><button type='button' class='close' data-dismiss='alert'>&times;</button><strong>Hey-Hey!</strong> Don't leave empty fields</div>");
      }
    };
  this.signout = function(){
      $.ajax({
        type: 'DELETE',
        contentType: 'application/json',
        url: '/api/signout',
        success: function(data, textStatus, jqXHR){
          window.location.replace("http://localhost:9393/");
        },
        error: function(jqXHR, textStatus, errorThrown){
          console.log(textStatus);
        }
      });
    };
  this.create = function(model, success_c, error_c){
      $.ajax({
        type: 'POST',
        contentType: 'application/json',
        url: model_url(model),
        dataType: "json",
        data: model_data(model),
        processData: false,
        success: function(data, textStatus, jqXHR){
          success_c.call(this);
        },
        error: function(jqXHR, textStatus, errorThrown){
          error_c.call(this);
        }
      });
    };
  this.read = function(model, success_c, error_c){
      $.ajax({
        type: 'GET',
        contentType: 'application/json',
        url: model_url(model),
        data: {'page_number': model['data']['page_number']},
        dataType: "json",
        success: function(data, textStatus, jqXHR){
          success_c.call(this);
        },
        error: function(jqXHR, textStatus, errorThrown){
          error_c.call(this);
        }
      });
    };
  this.update = function(model, success_c, error_c){
      $.ajax({
        type: 'UPDATE',
        contentType: 'application/json',
        url: model_url(model),
        dataType: "json",
        data: model_data(model),
        processData: false,
        success: function(data, textStatus, jqXHR){
          success_c.call(this);
        },
        error: function(jqXHR, textStatus, errorThrown){
          error_c.call(this);
        }
      });
    };
  this.delete = function(model, success_c, error_c){
      $.ajax({
        type: 'DELETE',
        contentType: 'application/json',
        url: model_url(model),
        dataType: "json",
        data: model_data(model),
        processData: false,
        success: function(data, textStatus, jqXHR){
          success_c.call(this);
        },
        error: function(jqXHR, textStatus, errorThrown){
          error_c.call(this);
        }
      });
    };
};

(jQuery)(function(){

  function capitalise(string){
    return string.charAt(0).toUpperCase() + string.slice(1);
  }
  
  var elems = ['title', 'intro', 'servings', 'minutes']

    $('#inputTitle').bind('input', function() { 
      $('#result #title').text($(this).val());
    });
    $('#inputIntro').bind('input', function() { 
      $('#result #intro').text($(this).val());
    });
    $('#inputTime').bind('input', function() { 
      $('#result #time').text($(this).val() + ' minutes');
    });
    $('#inputServings').bind('input', function() { 
      $('#result #servings').text($(this).val() + ' servings');
    });
    $('#inputSteps').bind('input', function() { 
      $('#result #steps').html(converter.makeHtml($(this).val()));
    });
});