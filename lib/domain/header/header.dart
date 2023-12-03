enum Header {
  CORS(header: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,locale",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
  }),
  JSON(header: {'Content-Type': 'application/json'}),
  TEXT(header: {'Content-Type': 'text/plain'});

  final Map<String, String> header;

  const Header({required this.header});
}
