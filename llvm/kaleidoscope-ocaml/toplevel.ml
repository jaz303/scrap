open Llvm

let rec main_loop stream =
	match Stream.peek stream with
	| None -> ()
	| Some (Token.Kwd ';') ->
		Stream.junk stream;
		main_loop stream
	| Some token ->
		begin
			try match token with
			| Token.Def ->
				let e = Parser.parse_definition stream in
            	print_endline "parsed a function definition.";
            	dump_value (Codegen.codegen_func e);
			| Token.Extern ->
				let e = Parser.parse_extern stream in
            	print_endline "parsed an extern.";
            	dump_value (Codegen.codegen_proto e);
			| _ ->
				let e = Parser.parse_toplevel stream in
            	print_endline "parsed a top-level expr";
            	dump_value (Codegen.codegen_func e);
			with Stream.Error s ->
				Stream.junk stream;
				print_endline s;
		end;
		print_string "ready> "; flush stdout;
		main_loop stream;