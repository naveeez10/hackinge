import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../repository/i_auth_repository.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(LoginState.initial());

  final IAuthRepository _repository;

  void resetOtp() {
    emit(state.copyWith(
      otp: '',
      showResendButton: true,
      isSubmittingOtp: false,
      otpError: none(),
    ));
  }

  void mobileChanged(String text) {
    emit(state.copyWith(mobileNumber: text));
  }

  void otpChanged(String text) {
    emit(state.copyWith(otp: text, otpError: none()));
  }

  bool isMobileNotValid() => state.mobileNumber.length != 10;

  Future<bool> sendOtp() async {
    emit(state.copyWith(isSubmittingMobile: true));
    final result = await _repository.sendOTP(mobileWithCode);
    emit(
      state.copyWith(isSubmittingMobile: false),
    );
    return result.fold(
      (l) {
        Fluttertoast.showToast(
          msg: (l is OtpNotSentFailure) ? l.error : 'Some error occurred. Please try again',
          backgroundColor: EBColors.symbeepLightOrangePrimary,
          textColor: Colors.white,
        );
        return false;
      },
      (r) => true,
    );
  }

  bool isOTPNotValid() => state.otp.length != 4;

  Future<Either<Failure, Map<String, dynamic>>> otpNextPressed() async {
    emit(state.copyWith(isSubmittingOtp: true));

    final result = await _repository.verifyMobile(
      mobileWithCode,
      state.otp,
    );

    emit(state.copyWith(
      isSubmittingOtp: false,
      otpError: optionOf(result.fold(
        (l) => l.maybeMap(
          noCampusInfo: (f) => null,
          userBanned: (f) => null,
          invalidInput: (f) => 'Invalid OTP',
          orElse: () => 'Some error occurred',
        ),
        (r) => null,
      )),
    ));

    return result;
  }

  void resendPressed() async {
    emit(state.copyWith(showResendButton: false));
    await _repository.resendOTP(mobileWithCode);
  }

  String get mobileWithCode => '+91${state.mobileNumber}';
}
