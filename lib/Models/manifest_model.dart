class ManifestModel{
  //for all
  final String? id;
  final String? name;
  final String? engine;
  final int? speakerCount;
  final bool? multilingual;
  final String? license;
  final String? downloadURL;
  final String? samplePath; 
  final bool? userVoice;

  //for multilingual
  final List<String>? languageList;

  //for monolingual
  final String? language;

  //for multi speaker
  final List<dynamic>? speakers;
  final int? idSpeaker;
  final String? sound;

  //for speaking after downloaded
  String? modelPath;
  String? voicesBin;
  String? ruleFsts;
  String? ruleFars;
  String? lexicon;
  String? tokenPath;
  String? eSpeakPath;

  ManifestModel({ 
    this.id,
    this.name,
    this.engine,
    this.speakerCount,
    this.userVoice,
    this.multilingual,
    this.license,
    this.downloadURL,
    this.samplePath,
    this.languageList,
    this.language,
    this.speakers,
    this.idSpeaker,
    this.sound,
    this.modelPath,
    this.voicesBin,
    this.ruleFsts,
    this.ruleFars,
    this.lexicon,
    this.tokenPath,
    this.eSpeakPath
  });

  factory ManifestModel.fromJson(Map<String, dynamic> json){
      return ManifestModel(
        id: json["id"],
        name: json["name"],
        engine: json["engine"],
        speakerCount: json["speaker_count"],
        userVoice: json["userVoice"],
        multilingual: json["multilingual"],
        license: json["license"],
        downloadURL: json["download_url"],
        samplePath: json["sample_path"],
        languageList: (json['languageList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
        language: json["language"],
        speakers: json["speakers"],
        idSpeaker: json["idSpeaker"],
        sound: json["sound"],
    );
  }
}