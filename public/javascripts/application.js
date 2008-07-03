$(document).ready(function(){
  
  // tabs for new post form
  $("#new-post-tabs > ul").tabs(
    // TODO clear validations on tab switch
    );
  
  
  // toggle extra fields display
  $(".extra-fields").hide();
  $(".show-extra-fields").click(function(){
    $(".extra-fields").toggle();
    return false;
  });


  // js form validations
  // TODO refactor this into one method
  $("#blog_form").validate({

     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
      });
    }
  });

  $("#video_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
      });
    }
  });

  $("#quote_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#image_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#link_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#code_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

});

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
    "text/javascript")} 
})

jQuery.validator.setDefaults({
  errorPlacement: function(error, element) {
       error.insertBefore(element);
     }
});