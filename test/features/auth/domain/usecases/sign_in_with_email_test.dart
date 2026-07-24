import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_in_with_email.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Validation used to sit inside `sign_in_screen.dart`. Now that it lives in
/// the use case it can be tested without building any UI.
void main() {
  late MockAuthRepository repository;
  late SignInWithEmail useCase;

  const user = AppUser(id: 'u1', email: 'ada@alustudent.com');

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignInWithEmail(repository);
  });

  test('rejects a malformed email without hitting the repository', () async {
    expect(
      () => useCase(email: 'not-an-email', password: 'secret123'),
      throwsA(isA<ValidationFailure>()),
    );
    verifyNever(
      () => repository.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  test('rejects a password shorter than six characters', () {
    expect(
      () => useCase(email: 'ada@alustudent.com', password: '123'),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('trims whitespace and forwards valid credentials', () async {
    when(
      () => repository.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => user);

    final result =
        await useCase(email: '  ada@alustudent.com  ', password: 'secret123');

    expect(result.id, 'u1');
    verify(
      () => repository.signInWithEmail(
        email: 'ada@alustudent.com',
        password: 'secret123',
      ),
    ).called(1);
  });
}
