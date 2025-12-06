app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
    ascii: "https://github.com/Hasnep/roc-ascii/releases/download/v0.3.1/1PCTQ0tzSijxfhxDg1k_yPtfOXiAk3j283b8EWGusVc.tar.br",
}

import pf.Stdout
import "data/day2.txt" as input : Str

main! = |_args|
    Stdout.line!("Answer to part 1: ${Num.to_str(part1(input))}")

example = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

part1 = |text|
    lines = inputToLists(text)
    lines
    |> List.map(|range| parse_range(range))
    |> List.keep_oks (|id| id)
    |> List.map(|n| calculate_sum_ids(n))
    |> List.sum

expect
    res = part1(example)
    res == 1227775554

calculate_sum_ids : (U64, U64) -> U64
calculate_sum_ids = |range_tuple|
    (a, b) = range_tuple
    List.range({ start: At a, end: At b })
    |> List.walk(
        0,
        |acc, elem|
            if number_is_mirror(elem) then
                acc + elem
            else
                acc,
    )

number_is_mirror = |number|
    utf8_list = Str.to_utf8(Num.to_str(number))
    utf8_list
    |> List.walk_with_index(
        Bool.false,
        |acc, _elem, index|
            split_list = List.split_at(utf8_list, index)
            if split_list.before == split_list.others then
                Bool.true
            else
                acc,
    )

parse_range = |range|
    when range is
        [a_str, b_str] ->
            a = Str.to_u64(a_str)?
            b = Str.to_u64(b_str)?
            Ok((a, b))

        _ -> Err(InvalidFormat)

inputToLists = |in|
    in
    |> Str.trim
    |> Str.split_on(",")
    |> List.map(|s| Str.split_on(s, "-"))
