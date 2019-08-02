class CategoryBigModel{
  String mallCategoryId;//类别id
  String mallCategoryName;//类别名称
  List<dynamic> bxMallSubDto;//小类列表
  String image;//类别图片
  Null comments;//列表描述

  //构造函数
  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.image,
    this.comments
  });

  //工厂模式-用这种模式可以省略New关键字
  factory CategoryBigModel.formJson(dynamic json){
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      comments: json['comments'],
      image: json['image'],
      bxMallSubDto: json['bxMallSubDto']
    );
  }
}

class CategoryBigListModel{
  List<CategoryBigModel> data;
  CategoryBigListModel(this.data);
  factory CategoryBigListModel.formJson(List json){
    return CategoryBigListModel(
      json.map((val){
        CategoryBigListModel.formJson(val);
      }).toList()
    );
  }
}