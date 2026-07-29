import 'package:flutter_test/flutter_test.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';

void main() {
  test('initials come from the display name when there is one', () {
    const user = AppUser(
      id: 'u1',
      email: 'ada.lovelace@alustudent.com',
      displayName: 'Ada Lovelace',
    );
    expect(user.initials, 'AL');
  });

  test('initials fall back to the email', () {
    const user = AppUser(id: 'u1', email: 'ada@alustudent.com');
    expect(user.initials, 'A');
  });

  test('only alustudent addresses count as verified students', () {
    const student = AppUser(id: 'u1', email: 'ada@alustudent.com');
    const outsider = AppUser(id: 'u2', email: 'ada@gmail.com');
    expect(student.isVerifiedStudent, isTrue);
    expect(outsider.isVerifiedStudent, isFalse);
  });
}
