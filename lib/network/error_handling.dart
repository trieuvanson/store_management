
import 'package:dio/dio.dart';

import 'error_res.dart';

class ErrorHandling {
  int code = 0;
  String message = "";

  ErrorHandling(response) {
    if (response is Response) {
      code = response.statusCode!;
    }
    message = getErrorMessage(response);
  }

  static String getErrorMessage(response) {
    try {
      if (response is Response) {
        {
          switch (response.statusCode) {
            case 200:
            case 201:
            case 202:
              return "Thành công";
            case 400:
              return "Vui lòng kiểm tra lại thông tin đăng nhập";
            case 401:
              return "Phiên đăng nhập đã hết hạn";
            case 404:
              return "Không tìm thấy tài nguyên";
            case 405:
              return "Phương thức không được hỗ trợ";
            case 500:
              return "Opps! Có lỗi xảy ra với máy chủ, vui lòng thử lại sau";
            default:
              if (response.statusMessage != null &&
                  response.statusMessage!.isNotEmpty) {
                return response.statusMessage!;
              }
              return 'Lỗi không xác định.';
          }
        }
      } else {
        return "Có lỗi xảy ra, vui lòng thử lại sau";
      }
    } catch (e) {
      return "Có lỗi xảy ra, vui lòng thử lại sau";
    }
  }

  static showMessage(e) {
    if (e is ErrorHandling) {
      return e.message;
    } else {
      return e.toString();
    }
  }

  @override
  String toString() {
    return message;
  }
}