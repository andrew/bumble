$(document).ready(function(){
  
  $("#new-post-tabs > ul").tabs();
  
  $(".extra-fields").hide();
  $(".show-extra-fields").click(function(){
    $(".extra-fields").toggle();
    return false;
  });
  
  $('.new_post').ajaxForm({
      target: '#posts',
      clearForm: true
  });
});

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
    "text/javascript")} 
})