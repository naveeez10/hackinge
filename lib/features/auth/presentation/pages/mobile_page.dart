import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../cubit/login/login_cubit.dart';

@RoutePage()
class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  final cubit = getIt<LoginCubit>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else if (Platform.isIOS) {
          exit(0);
        }
        return Future.value(true);
      },
      child: BlocProvider<LoginCubit>(
        create: (_) => cubit,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) => Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 56),
                        Center(
                          child: Text(
                            'Enter Phone Number',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 56),
                        TextField(
                          autofocus: true,
                          enabled: !context.read<LoginCubit>().state.isSubmittingMobile,
                          maxLength: 10,
                          style: SymBeepTextStyles.display_small.copyWith(height: 1),
                          keyboardType: TextInputType.number,
                          onChanged: cubit.mobileChanged,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Text(
                              '+91',
                              style: SymBeepTextStyles.display_small
                                  .copyWith(color: EBColors.symbeepDarkTextSecondary, height: 1),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? EBColors.symbeepDarkTextSecondary
                                    : EBColors.symbeepLightTextSecondary,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? EBColors.symbeepDarkTextSecondary
                                    : EBColors.symbeepLightTextSecondary,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SecondaryButton.next(
                      onTap: () async {
                        final result = await cubit.sendOtp();
                        if (result) {
                          AutoRouter.of(context).push(OtpRoute(cubit: cubit));
                        }
                      },
                      isDisabled: context.read<LoginCubit>().state.mobileNumber.length != 10,
                      isLoading: cubit.state.isSubmittingMobile,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
