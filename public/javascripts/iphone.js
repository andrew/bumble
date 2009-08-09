function unautocapitalize(cssClass){
  var elems = document.getElementsByClassName(cssClass);
  for (var j = 0; j < elems.length; j++){
    elems[j].setAttribute('autocapitalize', 'off');
  }
}

$(document).ready(function(){
  // disable autocapitalize on .url, .email fields
  unautocapitalize('url');
  unautocapitalize('email');
});