jQuery.fn.hintFields = function(){
  for (var i = 0, l = this.length; i < l; i++){
    if (!Modernizr.input.placeholder){ $('input:text', this[i]).hint();}
    $('textarea', this[i]).hint();
  }
};

$(document).ready(function(){
  // validator defaults
  jQuery.validator.setDefaults({
    errorPlacement: function(error, element){ error.insertBefore(element); },
    ignoreTitle: true
  });

  if ($.browser.webkit){
    $('input[type="search"]').attr({autosave: location.host, results: 10})
  }

  // rails ajax setup
  jQuery.ajaxSetup({
    'beforeSend': function(xhr){ xhr.setRequestHeader("Accept","text/javascript"); }
  });

  // crf protection for ajax requests
  $(document).ajaxSend(function(event, request, settings) {
    if (typeof(AUTH_TOKEN) == "undefined") {return;}
    // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });

  // open external links in a new window
  $('a[rel="external"]').click( function(){
    window.open($(this).attr('href'));
    return false;
  });

  // text field hints
  $('form').hintFields();

  // slide open/closed the formatting help div
  $('a.help').click(function(){
    $('#formatting').toggle(100);
    return false;
  });

  // expanding textareas
  // $('textarea').simpleautogrow();

  // setup validation and ajax comments forms
  $(".new_comment").validate({
    submitHandler: function(form){
      $(form).ajaxSubmit({
        beforeSubmit: function(){$('.new_comment input[type="submit"]').after('<img src="/images/loading.gif" class="loading" />');},
        complete: function(){$('.loading').remove();},
        success: function(data) {
          $('#comments').append(data);
          $('.blank').remove();
          $(form).resetForm().hintFields();
          },
          error:function(request, textStatus, errorThrown) {
            var message = (request.status == 401 || request.status == 403 || request.status == 406) ? 
              request.responseText : "An unknown error occurred. Support has been contacted.";
            alert(message);
            if (request.status == 406) {
              $(form).resetForm().hintFields();
            }
          }
      });
    }
  });

  // fade out flash
  setTimeout(function(){$(".flash").fadeOut(1000);},10000);

});