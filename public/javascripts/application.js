$(function(){
  $('.js__image-generator-form').change(imageUrl);
  $('textarea.js__image-generator-form').keyup(imageUrl);
  imageUrl();

  new Clipboard('.js__clip-button');
});

function imageUrl () {
  var parameters = [];
  $('.js__image-generator-form').each( function () {
    var $form = $(this);
    parameters[$form.attr('name')] = $form.val();
  });
  var imageUrl = $('body').data('urlroot') + '/' + parameters['image_name'] + '?text=' + encodeURI(parameters['text']) + '&pattern=' + parameters['pattern'] + '&mirror_copy=' + parameters['mirror_copy'] + '&font_name=' + parameters['font_name'] + '&size=' + parameters['size'];
  $('#inputUrl').val(imageUrl);
  $('#inputMarkdown').val('![zagin stamp](' + imageUrl + ')');
  $('.js__stamp-image-url').attr('src', imageUrl);
}
