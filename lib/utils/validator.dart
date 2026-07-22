class Validator {
  /// 校验时/分/秒输入
  /// 返回 null 表示通过；否则返回错误信息
  static String? validateHms(String h, String m, String s) {
    if (h.trim().isEmpty || m.trim().isEmpty || s.trim().isEmpty) {
      return '时 / 分 / 秒 不能为空';
    }

    final hi = int.tryParse(h) ?? -1;
    final mi = int.tryParse(m) ?? -1;
    final si = int.tryParse(s) ?? -1;

    if (hi < 0 || mi < 0 || si < 0) {
      return '请输入有效正整数';
    }

    if (hi == 0 || mi == 0 || si == 0) {
      return '时 / 分 / 秒 均不能为 0';
    }

    return null;
  }
}
