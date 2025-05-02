class ParsingHelper {
  static List<T2> parseListMethod<T1, T2>(dynamic value, {List<T2>? defaultValue}) {
    defaultValue ??= <T2>[];

    if (value == null) {
      return defaultValue;
    } else if (value is List) {
      try {
        List<T2?> list = value.map((e) => parseValue<T2>(e) as T2).toList();
        list.removeWhere((e) => e == null);

        return list.map<T2>((e) => e!).toList();
      } catch (e) {
        return defaultValue;
      }
    } else {
      return defaultValue;
    }
  }

  static T? parseValue<T>(dynamic value, {T? defaultValue}) {
    try {
      T? parsedValue = switch (T.toString()) {
        "dynamic" => value as T,
        "List" => parseListMethod(value) as T,
        "List<String>" => parseListMethod<dynamic, String>(value) as T,
        "List<int>" => parseListMethod<dynamic, int>(value) as T,
        "List<double>" => parseListMethod<dynamic, double>(value) as T,
        "List<bool>" => parseListMethod<dynamic, bool>(value) as T,
        _ => defaultValue,
      };
      return parsedValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
