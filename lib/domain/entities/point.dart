class Point {
  const Point({required this.x, required this.y});

  final int x;
  final int y;

  Point operator +(Point other) => Point(x: x + other.x, y: y + other.y);

  String toDisplayString() => '($x.$y)';

  String toApiString() => '($x,$y)';

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => toDisplayString();
}
