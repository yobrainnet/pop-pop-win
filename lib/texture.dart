#library('sweeper-texture');

#import('package:dart-xml/xml.dart');
#import('dart:io');
#import('dart:math');
#import('../../dartlib/lib/dartlib.dart');

#source('texture/texture_input.dart');

List<TextureInput> getTextures(String stringPath) {
  final path = new Path(stringPath);
  final file = new File.fromPath(path);
  final docString = file.readAsTextSync();

  final doc = XML.parse(docString);

  var rootDict = $(doc.children).first();
  final hashMap = _parseDict(rootDict);

  final frames = new List<TextureInput>();

  Map<String, Dynamic> frameMaps = hashMap['frames'];
  frameMaps.forEach((String key, Map<String, Dynamic> value) {
    final parsed = new TextureInput.fromHash(key, value);
    frames.add(parsed);
  });

  return frames;
}

HashMap<String, Dynamic> _parseDict(XmlElement element) {
  assert(element != null);
  assert(element.name == "dict");

  final children = $(element.children).toList();
  assert(children.length %2 == 0);

  final map = <String,Dynamic>{};
  for(int i= 0; i < children.length; i+=2) {
    final keyElement = children[i];
    assert(keyElement.name == 'key');
    final key = keyElement.text;

    final valueElement = children[i+1];
    final value = _parseValue(valueElement);

    map[key] = value;
  }

  return map;
}

Dynamic _parseValue(XmlElement element) {
  assert(element != null);
  switch(element.name) {
    case 'string':
      return element.text;
    case 'dict' :
      return _parseDict(element);
    case 'false' :
      return false;
    case 'true':
      return true;
    case 'integer':
      return parseInt(element.text);
    default:
      throw "support for ${element.name} has not implemented";
  }
}
