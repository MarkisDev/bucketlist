class UserModel {
  late String fullName;
  late String firstName;
  late String lastName;
  late String email;
  late String id;
  late String photoUrl;
  late String bucketId;

  UserModel(
      {required this.fullName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.id,
      required this.photoUrl,
      required this.bucketId});
}
