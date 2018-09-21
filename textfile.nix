{ stdenv }:

let
  text1 = ''
    Some
    Unindented
    Text
    In
  '';

  text2 = ''
    Context
        ${text1}
    Context
    	${text1}
    Context
  '';
in
stdenv.mkDerivation {
  name = "textfile";
  text = text2;

  buildCommand = ''
    echo "$text" > "$out"
  '';
}
