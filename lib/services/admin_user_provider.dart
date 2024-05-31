import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_user_service.dart';

final adminUserServiceProvider = Provider((ref) => AdminUserService());

final adminUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final adminUserService = ref.read(adminUserServiceProvider);
  return adminUserService.getUsers();
});

final adminEditUserProvider =
    FutureProvider.family<void, Map<String, String>>((ref, userData) async {
  final adminUserService = ref.read(adminUserServiceProvider);
  await adminUserService.updateUser(
    userData['userId']!,
    userData['username']!,
    userData['role']!,
  );
});

final adminDeleteUserProvider =
    FutureProvider.family<void, String>((ref, userId) async {
  final adminUserService = ref.read(adminUserServiceProvider);
  await adminUserService.deleteUser(userId);
});

final adminAddUserProvider =
    FutureProvider.family<void, Map<String, String>>((ref, userData) async {
  final adminUserService = ref.read(adminUserServiceProvider);
  await adminUserService.addUser(
    userData['username']!,
    userData['email']!,
  );
});

void refreshUsersProvider(WidgetRef ref) {
  ref.refresh(adminUserServiceProvider);
}
