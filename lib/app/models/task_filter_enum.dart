enum TaskFilterEnum {
  today('HOJE'),
  tomorrow('AMANHÃ'),
  week('SEMANA');

  const TaskFilterEnum(this.label);
  final String label;
}
