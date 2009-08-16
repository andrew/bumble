$(document).ready(function(){
  // disable autocapitalize on .url, .email fields
  $('.url, .email').each(function(){
    this.setAttribute('autocapitalize', 'off');
  });
});