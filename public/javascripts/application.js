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
  $("#new_blog_form").validate({

     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
      });
    }
  });

  $("#new_video_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
      });
    }
  });

  $("#new_quote_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#new_image_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#new_link_form").validate({
     submitHandler: function(form) {
     	$(form).ajaxSubmit( {
           target: '#posts',
           clearForm: true
       });
     }
  });

  $("#new_code_form").validate({
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