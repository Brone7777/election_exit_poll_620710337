class candidate {
  final int candidateNumber;
  final String candidateTitle;
  final String candidateFirstName;
  final String candidateLastName;

  candidate(
      {required this.candidateFirstName,
      required this.candidateLastName,
      required this.candidateNumber,
      required this.candidateTitle});

  factory candidate.fromJson(Map<String, dynamic> json) {
    return candidate(
        candidateFirstName: json["candidateFirstName"],
        candidateLastName: json["candidateLastName"],
        candidateNumber: json["candidateNumber"],
        candidateTitle: json["candidatTitle"]);
  }
}
