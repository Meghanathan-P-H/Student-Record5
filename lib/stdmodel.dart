const String studentsTable = 'students';

class StudentsFields {
  static final List<String> values = [id, name, age, email, domain, image];
  static const String id = 'id';
  static const String name = 'name';
  static const String age = 'age';
  static const String email = 'email';
  static const String domain = 'domain';
  static const String image = 'image';
}

class Students {
  int? id;
  String name;
  int? age;
  String email;
  String domain;
  String image;

  Students({
    this.id,
    this.name = '',
    this.age = 0,
    this.email = '',
    this.domain = '',
    this.image = '',
  });

  Students copy({
    int? id,
    String? name,
    int? age,
    String? email,
    String? domain,
    String? image,
  }) =>
      Students(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        email: email ?? this.email,
        domain: domain ?? this.domain,
        image: image ?? this.image,
      );

  static Students fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as int;
    final email = map['email'] as String;
    final domain = map['domain'] as String;
    final image = map['image'] as String;

    return Students(
      id: id,
      name: name,
      age: age,
      email: email,
      domain: domain,
      image: image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      StudentsFields.id: id,
      StudentsFields.name: name,
      StudentsFields.age: age,
      StudentsFields.email: email,
      StudentsFields.domain: domain,
      StudentsFields.image: image,
    };
  }
}
