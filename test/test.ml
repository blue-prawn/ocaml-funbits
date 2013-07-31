let exit_code = ref 0

let test lbl should bits1 bits2 =
  let d1 = List.fold_left Bits.set_bit Bits.zero bits1 in
  let d2 = List.fold_left Bits.set_bit Bits.zero bits2 in
  let res = Bits.subset_bits d1 d2 in
  if res = should then begin
    Printf.printf "Test %s: OK\n" lbl;
  end
  else begin
    exit_code := 1;
    Printf.eprintf "Test %s: ERROR\n" lbl;
    Printf.eprintf "d1 is subset of d2: (%B = %B)\n" res should;
    Printf.eprintf "bits1: %s\n" (Bits.string_of_bits d1);
    Printf.eprintf "bits2: %s\n" (Bits.string_of_bits d2);
  end

let test1 () =
  test "subset1" true
    [52;   36;   17;16;7;  3;0]
    [52;48;36;18;17;16;7;6;3;0]

let test2 () =
  test "subset2" false
    [   50;23;36;   17;16;7;  3;0]
    [52;      36;18;17;16;7;6;3;0]

let test3 () =
  let b0 = Bits.set_bits Bits.zero [40; 21; 20; 11; 6; 2] in
  let b1 = Bits.set_bits Bits.zero [    21;     11; 6; 2] in
  let b2 = Bits.unset_bits b0 [40; 20] in
  let res = Bits.eq b1 b2 in
  if res = true then begin
    Printf.printf "Test unset: OK\n";
  end
  else begin
    exit_code := 1;
    Printf.eprintf "Test unset: ERROR\n";
    Printf.eprintf "bits0: %s\n" (Bits.string_of_bits b0);
    Printf.eprintf "bits1: %s\n" (Bits.string_of_bits b1);
    Printf.eprintf "bits2: %s\n" (Bits.string_of_bits b2);
  end

let test4 () =
  let b1 = Bits.set_bits Bits.zero [2;3;30;44;50;51] in
  let b2 = Bits.set_bits Bits.zero [2;3;33;48;55] in
  let b3 = Bits.bits_or b1 b2 in
  if (Bits.to_string b3) =
    "0000001000110100010000000000100_1000000000000000000000000001100"
  then Printf.printf "Test OR: OK\n"
  else begin
    exit_code := 1;
    Printf.eprintf "Test OR: ERROR\n";
    Printf.eprintf "bits1: %s\n" (Bits.to_string b1);
    Printf.eprintf "bits2: %s\n" (Bits.to_string b2);
    Printf.eprintf "bits3: %s\n" (Bits.to_string b3);
  end

let test5 () =
  let b1 = Bits.set_bits Bits.zero [2;3;30;44;50;51] in
  let b2 = Bits.set_bits Bits.zero [2;3;33;48;55] in
  let b3 = Bits.bits_and b1 b2 in
  if (Bits.to_string b3) = "0000000000000000000000000001100"
  then Printf.printf "Test AND: OK\n"
  else begin
    exit_code := 1;
    Printf.eprintf "Test AND: ERROR\n";
    Printf.eprintf "bits1: %s\n" (Bits.to_string b1);
    Printf.eprintf "bits2: %s\n" (Bits.to_string b2);
    Printf.eprintf "bits3: %s\n" (Bits.to_string b3);
  end

let test6 () =
  let b1 = Bits.of_string "1001_0010_1110_0001" in
  let b2 = Bits.of_string "0100_0010_0111_0100" in
  let b3 = Bits.of_string "1101_0000_1001_0101" in
  let b4 = Bits.bits_xor b1 b2 in
  if (Bits.eq b3 b4)
  then Printf.printf "Test XOR: OK\n"
  else begin
    exit_code := 1;
    Printf.eprintf "Test XOR: ERROR\n";
    Printf.eprintf "bits1: %s\n" (Bits.to_string b1);
    Printf.eprintf "bits2: %s\n" (Bits.to_string b2);
    Printf.eprintf "bits3: %s\n" (Bits.to_string b3);
    Printf.eprintf "bits4: %s\n" (Bits.to_string b4);
  end

let test7 () =
  let b1 = Bits.of_string "1001_0000__0110_0001" in
  let b2 = Bits.set_bits Bits.zero [0;5;6;12;15] in
  if (Bits.eq b1 b2)
  then Printf.printf "Test of_string: OK\n"
  else begin
    exit_code := 1;
    Printf.eprintf "Test of_string: ERROR\n";
    Printf.eprintf "bits1: %s\n" (Bits.to_string b1);
    Printf.eprintf "bits2: %s\n" (Bits.to_string b2);
  end

let test8 () =
  let b1 = Bits.of_string "1001_0000__0110_0001" in
  let s2 = Bits.to_string b1 in
  let b2 = Bits.of_string s2 in
  if (Bits.eq b1 b2)
  then Printf.printf "Test to_string: OK\n"
  else begin
    exit_code := 1;
    Printf.eprintf "Test of_string: ERROR\n";
    Printf.eprintf "bits1: %s\n" (Bits.to_string b1);
    Printf.eprintf "bits2: %s\n" (Bits.to_string b2);
  end

let () =
  test1 ();
  test2 ();
  test3 ();
  test4 ();
  test5 ();
  test6 ();
  test7 ();
  test8 ();
  exit !exit_code;
;;