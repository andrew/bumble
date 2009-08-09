jQuery.fn.hintFields = function(){
  for (var i = 0; i < this.length; i++){
    if (!$.browser.safari){ $('input:text', this[i]).hint();}
    $('textarea', this[i]).hint();
  }
};

$(document).ready(function(){
  // validator defaults
  jQuery.validator.setDefaults({
    errorPlacement: function(error, element){ error.insertBefore(element); },
    ignoreTitle: true
  });

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

  // ajax delete
  $('a.delete').livequery('click', function(){
    var elem = $(this);
    if (confirm("Are you sure?")){
      $.post($(this).attr('href'), "_method=delete",function(){
        elem.closest('div').slideUp();
      });
    }
    return false;
  }).attr("rel", "nofollow");

  // open external links in a new window
  $('a[rel="external"]').click( function(){
    window.open($(this).attr('href'));
    return false;
  });

  // new post form tabs
  $("#new_post > ul").tabs({cookie: {}});

  if ($.cookie("hide_new_post") == 'false') {
    $('#new_post').show();
    $('a.open').hide();
  }
  else {
    $('#new_post').hide();
    $('a.open').show();
  }

  $('.ui-tabs-nav').bind('tabsselect', function(event, ui) {
    $('label.error').remove();
    $('a.more').show();
    $('div.more').hide();
    $('.ui-tabs-nav').hintFields();
  });

  $('a.open').click(function(){
    $('a.open').fadeOut();
    $('#new_post').slideDown();
    $.cookie("hide_new_post", 'false');
    return false;
  });

  $('a.close').click(function(){
    $('#new_post').slideUp(function(){
      $('a.open').fadeIn();
    });
    $.cookie("hide_new_post", 'true');
    $('.preview').remove();
    return false;
  });

  // extra post options
  $('#new_post div.more').hide();
  $('#new_post a.more').click(function(){
    $('#new_post div.more').slideDown();
    $(this).hide();
    return false;
  });

  // text field hints
  $('form').hintFields();
  
  $('a.help').click(function(){
    $('#formatting').toggle(100);
    return false;
  });

  // expanding textareas
  $('textarea').jGrow();

  // setup validation and ajax post forms
  $(".new_post").each(function(){
    $(this).validate({
      rules: {
        'video[video_embed]': {
          required: "#video_link_url:blank"
        }
      },
      submitHandler: function(form){
        $(form).ajaxSubmit({
          beforeSubmit: function(){$('.new_post .submit').after('<img src="/images/loading.gif" class="loading" />');},
          complete: function(){$('.loading').remove();},
          success: function(data){
            $('.preview').remove();
            $('#posts').prepend(data);
            if ($('.preview').size() == 0){
              $(form).resetForm();
            }
            $(form).hintFields();
          },
          error:function(request, textStatus, errorThrown) {
            var message = (request.status == 401 || request.status == 403) ? 
              request.responseText : "An unknown error occurred. Support has been contacted.";
            alert(message);
          }

        });
      }
    });
  });

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
            var message = (request.status == 401 || request.status == 403) ? 
              request.responseText : "An unknown error occurred. Support has been contacted.";
            alert(message);
          }
      });
    }
  });

  // fade out flash
  setTimeout(function(){$(".flash").fadeOut(1000);},10000);

  // Google analtyics
  var gaTrackCode = "UA-265870-16";
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  jQuery.getScript(gaJsHost + "google-analytics.com/ga.js", function(){
    var pageTracker = _gat._getTracker(gaTrackCode);
    pageTracker._initData();
    pageTracker._trackPageview();
  });
});