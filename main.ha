use fmt;
use strings;
use strconv;

const upperblock = "▀";
const lowerblock = "▄";
const fullblock  = " ";

// https://ecma-international.org/publications-and-standards/standards/ecma-48/
//
// fg, bg -- color
// 30, 40 => black
// 31, 41 => red
// 32, 42 => green
// 33, 43 => yellow
// 34, 44 => blue
// 35, 45 => magenta
// 36, 46 => cyan
// 37, 47 => white

fn tint(block: str, color: str) str = {
	const csi = "\x1b[";
	const reset = "\x1b[m";
	const p = if (block == " ") "4" else "3";

	return strings::concat(csi, p, color, "m", block, reset)!;
};

export fn main() void = {
	fmt::printfln("{}", tint(upperblock, "1"))!;
};

