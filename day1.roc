app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import pf.Stdout
import "data/day1.txt" as input : Str

main! = |_args|
    Stdout.line!("Answer to part 1: ${Num.to_str(part1 input)}")

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

expect
    result = part1(example)
    result == 3

part1_walker = |acc, rotation|
    (dial, password) = acc
    # Part 1
    num = dial + rotation

    _ = dbg("${Num.to_str(num)}")

    new_dial =
        if num < 0 or num >= 100 then
            num % 100
        else
            num

    debug = "Enter walk dial:${Num.to_str(dial)}, rotation:${Num.to_str(rotation)}, new_dial:${Num.to_str(new_dial)},  password:${Num.to_str(password)}"
    _ = dbg(debug)

    if new_dial == 0 then
        (new_dial, password + 1)
    else
        (new_dial, password)

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
