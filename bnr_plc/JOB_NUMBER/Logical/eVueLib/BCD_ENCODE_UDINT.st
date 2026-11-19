
(* TODO: Add your comment here *)
FUNCTION_BLOCK BCD_Encode_UDINT

	Output := 0;

	IF Input.0 THEN
		Output := Output + 1;
	END_IF;
	IF Input.1 THEN
		Output := Output + 2;
	END_IF;
	IF Input.2 THEN
		Output := Output + 4;
	END_IF;
	IF Input.3 THEN
		Output := Output + 8;
	END_IF;
	IF Input.4 THEN
		Output := Output + 10;
	END_IF;
	IF Input.5 THEN
		Output := Output + 20;
	END_IF;
	IF Input.6 THEN
		Output := Output + 40;
	END_IF;
	IF Input.7 THEN
		Output := Output + 80;
	END_IF;
	IF Input.8 THEN
		Output := Output + 100;
	END_IF;
	IF Input.9 THEN
		Output := Output + 200;
	END_IF;
	IF Input.10 THEN
		Output := Output + 400;
	END_IF;
	IF Input.11 THEN
		Output := Output + 800;
	END_IF;
	IF Input.12 THEN
		Output := Output + 1000;
	END_IF;
	IF Input.13 THEN
		Output := Output + 2000;
	END_IF;
	IF Input.14 THEN
		Output := Output + 4000;
	END_IF;
	IF Input.15 THEN
		Output := Output + 8000;
	END_IF;
	IF Input.16 THEN
		Output := Output + 10000;
	END_IF;
	IF Input.17 THEN
		Output := Output + 20000;
	END_IF;
	IF Input.18 THEN
		Output := Output + 40000;
	END_IF;
	IF Input.19 THEN
		Output := Output + 80000;
	END_IF;
	IF Input.20 THEN
		Output := Output + 100000;
	END_IF;
	IF Input.21 THEN
		Output := Output + 200000;
	END_IF;
	IF Input.22 THEN
		Output := Output + 400000;
	END_IF;
	IF Input.23 THEN
		Output := Output + 800000;
	END_IF;
	IF Input.24 THEN
		Output := Output + 1000000;
	END_IF;
	IF Input.25 THEN
		Output := Output + 2000000;
	END_IF;
	IF Input.26 THEN
		Output := Output + 4000000;
	END_IF;
	IF Input.27 THEN
		Output := Output + 8000000;
	END_IF;
	IF Input.28 THEN
		Output := Output + 100000000;
	END_IF;
	IF Input.29 THEN
		Output := Output + 200000000;
	END_IF;
	IF Input.30 THEN
		Output := Output + 400000000;
	END_IF;
	IF Input.31 THEN
		Output := Output + 800000000;
	END_IF;

END_FUNCTION_BLOCK
