app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import pf.Stdout
import "data/day1.txt" as input : Str

main! = |_args|
    _ = Stdout.line!("Answer to part 1: ${Num.to_str(part1 input)}")
    Stdout.line!("Answer to part 2: ${Num.to_str(part2 input)}")

example =
    """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

part1_walker = |acc, rotation|
    (dial, password) = acc
    # Part 1
    num = dial + rotation

    _ = dbg("${Num.to_str(num)}")
    new_dial =
        if num < 0 or num >= 100 then
            # Implement a positive sign modulo like Python, with a little bit of help from AI
            ((num % 100) + 100) % 100
        else
            num

    debug = "Enter walk dial:${Num.to_str(dial)}, rotation:${Num.to_str(rotation)}, new_dial:${Num.to_str(new_dial)},  password:${Num.to_str(password)}"
    _ = dbg(debug)

    if new_dial == 0 then
        (new_dial, password + 1)
    else
        (new_dial, password)

expect
    _ = dbg("--Part 1--")
    result = part1(example)
    result == 3

part2_walker = |acc, rotation|
    (dial, password) = acc
    # Part 1
    num = dial + rotation

    _ = dbg("${Num.to_str(num)}")

    new_dial =
        if num < 0 or num >= 100 then
            # Implement a positive sign modulo like Python, with a little bit of help from AI
            ((num % 100) + 100) % 100
        else
            num

    debug = "Enter walk rotation:${Num.to_str(rotation)}, dial:${Num.to_str(new_dial)}"
    _ = dbg(debug)
    pass_through_zero =
        if (num < -100 or num > 100) then
            _ = dbg("${Num.to_str(dial)} + Num.abs(${Num.to_str(rotation)}) // 100 =")
            (dial + Num.abs(rotation)) // 100
        else if (-100 < num and num < 0 and dial != 0) then
            1
        else
            0
    _ = dbg("Passed through zero ${Num.to_str(pass_through_zero)} times")
    if new_dial == 0 then
        _ = dbg("Points at zero")
        (new_dial, (password + 1) + pass_through_zero)
    else
        (new_dial, password + pass_through_zero)

expect
    _ = dbg("--Part 2--")
    result = part2(example)
    result == 6

generic = |text, walker|
    lines = inputToLists(text)
    (_res_dial, res_password) =
        lines
        |> List.map(|line| parse_rotation line)
        |> List.keep_oks (|id| id)
        |> List.walk(
            (50, 0),
            walker,
        )
    res_password

part1 = |text|
    generic(text, part1_walker)

part2 = |text|
    generic(text, part2_walker)

parse_rotation : Str -> Result I64 _
parse_rotation = |line|
    bytes = Str.to_utf8(line)
    when bytes is
        ['L', .. as rest] ->
            distance_str = Str.from_utf8(rest)?
            distance = Str.to_i64(distance_str)?
            Ok(distance * -1)

        ['R', .. as rest] ->
            distance_str = Str.from_utf8(rest)?
            distance = Str.to_i64(distance_str)?
            Ok(distance)

        _ -> Ok(0)

inputToLists = |in|
    in
    |> Str.trim
    |> Str.split_on("\n")
