import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';

abstract class IAuthRepository {
  Future<Either<Failure, Unit>> sendOTP(String mobile);

  Future<Either<Failure, Unit>> resendOTP(String mobile);

  Future<Either<Failure, Map<String, dynamic>>> verifyMobile(String mobile, String otp);
}
