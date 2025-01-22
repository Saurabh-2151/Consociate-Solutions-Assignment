class product {
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<Results>? results;

  product({this.totalPages, this.currentPage, this.pageSize, this.results});

  product.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pages'] = this.totalPages;
    data['current_page'] = this.currentPage;
    data['page_size'] = this.pageSize;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? name;
  String? nameLocale;
  String? modifierGroupDescription;
  String? modifierGroupDescriptionLocale;
  String? pLU;
  int? min;
  int? max;
  bool? active;
  int? vendorId;

  Results(
      {this.id,
        this.name,
        this.nameLocale,
        this.modifierGroupDescription,
        this.modifierGroupDescriptionLocale,
        this.pLU,
        this.min,
        this.max,
        this.active,
        this.vendorId});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameLocale = json['name_locale'];
    modifierGroupDescription = json['modifier_group_description'];
    modifierGroupDescriptionLocale = json['modifier_group_description_locale'];
    pLU = json['PLU'];
    min = json['min'];
    max = json['max'];
    active = json['active'];
    vendorId = json['vendorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_locale'] = this.nameLocale;
    data['modifier_group_description'] = this.modifierGroupDescription;
    data['modifier_group_description_locale'] =
        this.modifierGroupDescriptionLocale;
    data['PLU'] = this.pLU;
    data['min'] = this.min;
    data['max'] = this.max;
    data['active'] = this.active;
    data['vendorId'] = this.vendorId;
    return data;
  }
}