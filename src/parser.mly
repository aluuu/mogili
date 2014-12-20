%token <string> TEXT
%token <string> VARIABLE
%token OPEN_VAR_BRACE
%token CLOSE_VAR_BRACE
%token EOF

%start <Types.value option> prog
%%

prog:
  | EOF {None}
  | v = template {Some v}

template:
  | var = VARIABLE { `Variable var }
  | s = TEXT { `Text s }
