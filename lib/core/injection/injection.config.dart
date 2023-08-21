// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hackinge/core/injection/module.dart' as _i6;
import 'package:hackinge/features/auth/presentation/cubit/auth/auth_cubit.dart'
    as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i5;

const String _prod = 'prod';
const String _test = 'test';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.AuthCubit>(() => _i3.AuthCubit());
    gh.lazySingleton<_i4.Dio>(
      () => registerModule.dioProd,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i5.Logger>(
      () => registerModule.loggerProd,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i5.Logger>(
      () => registerModule.loggerTest,
      registerFor: {_test},
    );
    return this;
  }
}

class _$RegisterModule extends _i6.RegisterModule {}
