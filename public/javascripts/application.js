$(function(){
  setupImageForm();
  setupComicForm();
});

function setupImageForm () {
  $('.js__image-generator-form').change(imageUrl);
  $('textarea.js__image-generator-form').keyup(imageUrl);
  imageUrl();

  new Clipboard('.js__clip-button');
}

function setupComicForm () {
  $('.js__comic-image-url').on("load", function () { $('.js__comic-update').prop('disabled', false) });
  $('.js__comic-generator-form').change(comicUrl);
  $('input.js__comic-generator-form').keyup(comicUrl);
  $('textarea.js__comic-generator-form').keyup(comicUrl);
  $('.js__comic-update').click(updateComic);
  comicUrl();
}

function comicUrl () {
  var parameterStringArray = [];
  $('.js__comic-generator-form').each( function () {
    var $form = $(this);
    parameterStringArray.push($form.attr('name') + '=' + encodeURI($form.val()));
  });
  var comicUrl = $('body').data('urlroot') + '/comic?' + parameterStringArray.join('&');
  $('#inputUrl').val(comicUrl);
}

function updateComic () {
  $('.js__comic-update').attr('disabled', true);
  comicUrl = $('#inputUrl').val();
  $('.js__comic-image-url').attr('src', comicUrl);
}

function imageUrl () {
  var parameters = [];
  $('.js__image-generator-form').each( function () {
    var $form = $(this);
    parameters[$form.attr('name')] = $form.val();
  });
  var imageUrl = $('body').data('urlroot') + '/' + parameters['image_name'] + '?text=' + encodeURI(parameters['text']) + '&text_color=' + parameters['text_color'] + '&pattern=' + parameters['pattern'] + '&mirror_copy=' + parameters['mirror_copy'] + '&font_name=' + parameters['font_name'] + '&size=' + parameters['size'];
  $('#inputUrl').val(imageUrl);
  $('#inputMarkdown').val('![zagin stamp](' + imageUrl + ')');
  $('.js__stamp-image-url').attr('src', imageUrl);
}
