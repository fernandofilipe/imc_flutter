class ImcResponse {
  bool error;
  String title;
  String message;
  dynamic data;

  ImcResponse({
    this.error = false,
    this.title = "",
    this.message = "",
    this.data,
  });
}
