$(document).ready(function(){
  // ajax delete
  $('a.delete').live('click', function(){
    var elem = $(this);
    if (confirm("Are you sure?")){
      $.post($(this).attr('href'), "_method=delete",function(){
        elem.closest('div').slideUp();
      });
    }
    return false;
  }).attr("rel", "nofollow");
  
  // new post form tabs
  $("#new_post").tabs({cookie: {}});

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
          beforeSubmit: function(){
            $('.new_post .submit').after('<img src="/images/loading.gif" class="loading" />');
            $('.new_post :submit').attr('disabled', 'disabled');
            },
          complete: function(){
            $('.loading').remove();
            $('.new_post :submit').removeAttr('disabled');
            },
          success: function(data){
            $('.preview').remove();
            $('#posts').prepend(data);
            if ($('.preview').size() === 0){
              $(form).resetForm();
              if ($('.pagination').size() > 0){
                $('#posts .post:last').remove();
              }
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
});