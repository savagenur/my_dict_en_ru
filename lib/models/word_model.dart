class WordModel {
  List<Def>? def;

  WordModel({this.def});

  WordModel.fromJson(Map<String, dynamic> json) {
    if (json['def'] != null) {
      def = <Def>[];
      json['def'].forEach((v) {
        def!.add(new Def.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.def != null) {
      data['def'] = this.def!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Def {
  String? text;
  String? pos;
  String? ts;
  List<Tr>? tr;

  Def({this.text, this.pos, this.ts, this.tr});

  Def.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    pos = json['pos'];
    ts = json['ts'];
    if (json['tr'] != null) {
      tr = <Tr>[];
      json['tr'].forEach((v) {
        tr!.add(new Tr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['pos'] = this.pos;
    data['ts'] = this.ts;
    if (this.tr != null) {
      data['tr'] = this.tr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tr {
  String? text;
  String? pos;
  String? gen;
  int? fr;
  List<Syn>? syn;
  List<Mean>? mean;
  List<Ex>? ex;
  String? asp;

  Tr(
      {this.text,
      this.pos,
      this.gen,
      this.fr,
      this.syn,
      this.mean,
      this.ex,
      this.asp});

  Tr.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    pos = json['pos'];
    gen = json['gen'];
    fr = json['fr'];
    if (json['syn'] != null) {
      syn = <Syn>[];
      json['syn'].forEach((v) {
        syn!.add(new Syn.fromJson(v));
      });
    }
    if (json['mean'] != null) {
      mean = <Mean>[];
      json['mean'].forEach((v) {
        mean!.add(new Mean.fromJson(v));
      });
    }
    if (json['ex'] != null) {
      ex = <Ex>[];
      json['ex'].forEach((v) {
        ex!.add(new Ex.fromJson(v));
      });
    }
    asp = json['asp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['pos'] = this.pos;
    data['gen'] = this.gen;
    data['fr'] = this.fr;
    if (this.syn != null) {
      data['syn'] = this.syn!.map((v) => v.toJson()).toList();
    }
    if (this.mean != null) {
      data['mean'] = this.mean!.map((v) => v.toJson()).toList();
    }
    if (this.ex != null) {
      data['ex'] = this.ex!.map((v) => v.toJson()).toList();
    }
    data['asp'] = this.asp;
    return data;
  }
}

class Syn {
  String? text;
  String? pos;
  String? gen;
  int? fr;
  String? asp;

  Syn({this.text, this.pos, this.gen, this.fr, this.asp});

  Syn.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    pos = json['pos'];
    gen = json['gen'];
    fr = json['fr'];
    asp = json['asp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['pos'] = this.pos;
    data['gen'] = this.gen;
    data['fr'] = this.fr;
    data['asp'] = this.asp;
    return data;
  }
}

class Mean {
  String? text;

  Mean({this.text});

  Mean.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Ex {
  String? text;
  List<Tr>? tr;

  Ex({this.text, this.tr});

  Ex.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['tr'] != null) {
      tr = <Tr>[];
      json['tr'].forEach((v) {
        tr!.add(new Tr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.tr != null) {
      data['tr'] = this.tr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}