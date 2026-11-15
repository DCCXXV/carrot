use fmt;
use strings;
use strconv;

const upperblock = '▀';
const lowerblock = '▄';
const fullblock  = ' ';

// https://ecma-international.org/publications-and-standards/standards/ecma-48/
//
// dark    light
// fg, bg, fg, bg  -- color
//
// 30, 40, 90, 100 => black
// 31, 41, 91, 101 => red
// 32, 42, 92, 102 => green
// 33, 43, 93, 103 => yellow
// 34, 44, 94, 104 => blue
// 35, 45, 95, 105 => magenta
// 36, 46, 96, 106 => cyan
// 37, 47, 97, 107 => white

fn tint(block: str, color: str) str = {
	const csi = "\x1b[";
	const reset = "\x1b[m";
	const p = if (block == " ") "4" else "3";

	return strings::concat(csi, p, color, "m", block, reset)!;
};

// .   => empty
// 0-7 => color

const xolz: []str = [
	"1 . 1 . . 2 . . 4 4 4 . . 3 .",
	". 1 . . 2 2 2 . 4 . 4 . 3 . 3",
	"1 . 1 . . 2 . . 4 4 4 . 3 3 3",
	". . . . . . . . . . . . . . ."
];

fn print_slice(s: []str) void = {
	let w = len(s[0]);
	
	// 2 lines will be parsed at the same time per step
	//
	// 1 . 1 \_ 1 character height
	// . 1 . /
	// 1 . 1 \_ 1 character height
	// . . . /
	
	let text = strings::dup("")!;
	
	for (let i = 0z; i < len(s); i += 2) {
		let uh = strings::toutf8(s[i]);
		let lw = strings::toutf8(s[i+1]);
		// Skip spaces
		for (let j = 0z; j < w; j += 2) {
			let color = '5';
			let block = ' ';
			
			if (uh[j] == '.' && lw[j] != '.') {
				block = lowerblock;
				color = lw[j]: rune;
			} else if (uh[j] != '.' && lw[j] == '.') {
				block = upperblock;
				color = uh[j]: rune;
 			} else if (uh[j] == '.' && lw[j] == '.') {
				text = strings::concat(text, " ")!;
				continue;
			} else {
				color = uh[j]: rune;
			};

			let scolor = strings::fromrunes([color])!;
			defer free(scolor);

			let sblock = strings::fromrunes([block])!;
			defer free(sblock);

			text = strings::concat(text, tint(sblock, scolor))!;
		};
		fmt::println(text)!;
		text = strings::dup("")!;
	};

	free(text);
};

export fn main() void = {
	print_slice(xolz);
};

