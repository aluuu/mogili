{
  open Lexing
  open Parser

  exception SyntaxError of string

  type lexer_mode = Text | Variable

  let current_mode = ref Text

  let buffer = Buffer.create 128

  let reset_buffer () =
    let text = Buffer.contents buffer in
    Buffer.reset buffer;
    text

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
                 pos_lnum = pos.pos_lnum + 1
      }
}

let white = [' ' '\t']+

let newline = '\r' | '\n' | "\r\n"

let variable_name = [ 'A'-'Z' 'a'-'z' '_' '0'-'9']

rule
  read = parse
    | white { read lexbuf }
    | newline { next_line lexbuf; read lexbuf }
    | "{{" {
          match !current_mode with
          | Text -> current_mode := Variable;
                    TEXT (reset_buffer ())
          | Variable -> raise (SyntaxError "Unexpected start of variable block inside variable block")
        }
    | "}}" {
          match !current_mode with
          | Text -> raise (SyntaxError "Unexpected end of variable block")
          | Variable -> current_mode := Text;
                        VARIABLE (reset_buffer ())
        }
    | _ { Buffer.add_string buffer (Lexing.lexeme lexbuf); read lexbuf }
    | eof { match (reset_buffer (), !current_mode) with
            | "", Text -> EOF
            | _, Variable -> raise (SyntaxError "Unclosed variable block")
            | _ as s, Text -> TEXT s }
