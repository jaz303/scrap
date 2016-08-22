let main () =
	Hashtbl.add Parser.binop_precedence '<' 10;
	Hashtbl.add Parser.binop_precedence '+' 20;
	Hashtbl.add Parser.binop_precedence '-' 20;
	Hashtbl.add Parser.binop_precedence '*' 40;

	print_string "ready> "; flush stdout;
	let stream = Lexer.lex (Stream.of_channel stdin) in
	Toplevel.main_loop stream;
;;

main ()