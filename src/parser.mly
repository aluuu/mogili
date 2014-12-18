%token <string> TEXT
%token <string> VARIABLE
%token OPEN_VAR_BRACE
%token CLOSE_VAR_BRACE
%token EOF

%start <Types.value option> prog
%%

prog:
  | EOF {None}
  | v = value {Some v}

value:
  | OPEN_VAR_BRACE var = VARIABLE CLOSE_VAR_BRACE { `Variable var }
  | s = TEXT { `Text s }
