type token = TEXT of string
           | VARIABLE of string
           | OPEN_VAR_BRACE
           | CLOSE_VAR_BRACE
           | EOF

type value = [ `Text of string
             | `Variable of string]
