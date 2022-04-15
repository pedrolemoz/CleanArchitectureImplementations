class FirebaseUser {
  final String uniqueIdentifier;

  const FirebaseUser({required this.uniqueIdentifier});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirebaseUser && other.uniqueIdentifier == uniqueIdentifier;
  }

  @override
  int get hashCode => uniqueIdentifier.hashCode;
}
