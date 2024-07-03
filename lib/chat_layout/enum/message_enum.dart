enum MessageEnum{
  text('text'),
  image('image'),
  video('video'),
  audio('audio'),
  gif('gif');



  const MessageEnum(this.type);
    final String type;
}


extension ConvertMessage on String{
  MessageEnum toEnum(){
    switch (this) {
      case 'text':
        return MessageEnum.text;
        case 'video':
        return MessageEnum.video;
        case 'audio':
        return MessageEnum.audio;
        case 'image':
        return MessageEnum.image;
        case 'gif':
        return MessageEnum.gif;
        
      default:
      return MessageEnum.text;
    }
  }
}