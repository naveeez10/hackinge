import 'package:dartz/dartz.dart';
import 'package:hackinge/features/auth/repository/i_auth_repository.dart';

import '../../../core/errors/failures.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, Unit>> sendOTP(String mobile) {}

  @override
  Future<Either<Failure, Unit>> resendOTP(String mobile) {}

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyMobile(String mobile, String otp) {}
}
