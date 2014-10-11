CKEDITOR.editorConfig = function(config) {
  config.language = 'en';
  config.width = '500';
  config.resize_dir = 'both';
  config.resize_maxWidth = '920';
  config.removePlugins = 'elementspath';
  config.scayt_autoStartup = true;
  config.toolbar_Pure = [
    {
      name: 'document',
      items: ['Source']
    }, {
      name: 'clipboard',
      items: ['Undo', 'Redo']
    }, {
      name: 'editing',
      items: ['SpellChecker', 'Scayt']
    }, {
      name: 'basicstyles',
      items: ['Bold', 'Italic', 'Underline']
    }, {
      name: 'insert',
      items: ['Image', 'Flash']
    }, {
      name: 'links',
      items: ['Link', 'Unlink']
    }, '/', {
      name: 'paragraph',
      items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl']
    }, {
      name: 'styles',
      items: ['Format']
    }, '/'
  ];
  config.toolbar = 'Pure';
  return true;
};
