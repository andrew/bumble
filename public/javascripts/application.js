$(document).ready(function(){
  $("#new-post-tabs > ul").tabs();
  $(".extra-fields").hide();
  $(".show-extra-fields").click(function(){
    $(".extra-fields").toggle();
    return false;
  })
});
