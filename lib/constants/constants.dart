const Map<String, List<String>> extensions = {
  'image': [
    'png', 'jpg', 'bmp', 'tiff', 'ico'
  ],
  'video': [
    'mp4', 'avi', 'mkv', 'flv', 'webm', 'mov', 'mlv', 'm4v',  '3gp', 'mpeg'
  ],
  'audio': [
    'mp3', 'wmv', 'wav', 'ogg', '3gpp'
  ],
  'icon': [
    'ico'
  ],
};

const excludeFormats = ['exe', 'txt', 'psd', 'ini', 'docx', 'doc', 'xlsx', 'xls', 'pptx', 'ppt', 'psd', 'pdf'];

String systemDirectory = '';