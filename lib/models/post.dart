class Album {
  final int resultCode;
  final data;
  final String message;

  Album({this.resultCode, this.data, this.message});

  factory Album.fromJson(Map<String, dynamic> json) {
    // print("json: ${json['resultCode']}");
    return Album(
        resultCode: json['resultCode'],
        data: json['data'],
        message: json['message']);
  }
}