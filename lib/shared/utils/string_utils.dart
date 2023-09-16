class StringUtils {
  static String getInitials(String name) {
    if (name.isEmpty) {
      return "DC";
    }

    final tokens = name.trim().split(" ");

    if (tokens.length <= 1) {
      return "${tokens[0][0]}${tokens[0][1]}".toUpperCase();
    }

    return "${tokens[0][0]}${tokens[1][0]}".toUpperCase();
  }
}
