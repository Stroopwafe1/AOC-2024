if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();
const input: Array<string> = content.split('\n');

type Pos = {x: number, y: number};

const width = input[0].length;
const height = input.length;

const getCell = (x: number, y: number) => {
	if (x < 0 || x > width) return -1;
	if (y < 0 || y >= height) return -1;
	const string: string = input[y];
	return Number.parseInt(string[x]);
}

const scores = [];
let sum = 0;
input.forEach((line, y) => {
	for (let i = 0; i < line.length; i++) {
		let num = Number.parseInt(line[i]);
		if (num !== 0) continue;
		let tempSum = 0;
		const stack: Array<Pos> = [{x: i, y}];
		const uniques = {};

		while (stack.length > 0) {
			const pos = stack.pop();
			num = getCell(pos.x, pos.y);
			if (num === 9) {
				if (!(`X${pos.x}Y${pos.y}` in uniques)) {
					uniques[`X${pos.x}Y${pos.y}`] = 1;
				} else {
					uniques[`X${pos.x}Y${pos.y}`]++;
				}
				sum++;
				continue;
			}
			const up = getCell(pos.x, pos.y - 1);
			const down = getCell(pos.x, pos.y + 1);
			const left = getCell(pos.x - 1, pos.y);
			const right = getCell(pos.x + 1, pos.y);
			if (up === num + 1) {
				stack.push({x: pos.x, y: pos.y - 1});
			}
			if (down === num + 1) {
				stack.push({x: pos.x, y: pos.y + 1});
			}
			if (left === num + 1) {
				stack.push({x: pos.x - 1, y: pos.y});
			}
			if (right === num + 1) {
				stack.push({x: pos.x + 1, y: pos.y});
			}
		}
		scores.push(Object.keys(uniques).length);
	}
});

console.log('solution part 1: ', scores.reduce((acc, cur) => acc + cur));
console.log('solution part 2: ', sum);
