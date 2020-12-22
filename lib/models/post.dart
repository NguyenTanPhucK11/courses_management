class GetApi {
  final int resultCode;
  final data;
  final String message;

  GetApi({this.resultCode, this.data, this.message});

  factory GetApi.fromJson(Map<String, dynamic> json) {
    return GetApi(
        resultCode: json['resultCode'],
        data: json['data'],
        message: json['message']);
  }
}