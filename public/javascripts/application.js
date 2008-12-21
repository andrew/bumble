$(document).ready(function(){
  
  // tabs for new post form
  $("#new-post-tabs > ul").tabs();
    
  // remove validations on tab switch
  $('.ui-tabs-nav').bind('tabsselect', function(event, ui) {
    $("label.error").each(function(){$(this).remove();});
  });
  
  // toggle extra fields display
  $(".extra-fields").hide();
  $(".show-extra-fields").click(function(){
    $(this).toggleClass('selected')
    $(".extra-fields").toggle();
    return false;
  });

  // setup validation and ajax post forms
  $(".new_post").each(function(){
    $( this ).validate({
       submitHandler: function(form) {
       	$(form).ajaxSubmit( {
             target: '#posts',
             clearForm: true
        });
      }
    });
  });

	// the ajax comments
	$("#new_comment").submitWithAjax();

});

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
    "text/javascript")} 
});

jQuery.validator.setDefaults({
  errorPlacement: function(error, element) {
       error.insertBefore(element);
     }
});

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};