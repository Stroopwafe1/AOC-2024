if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();
const input: Array<string> = content.split('\n');

type Pos = {x: number, y: number};
const vertical = 0;
const horizontal = 1;

const width = input[0].length;
const height = input.length;

const getCell = (x: number, y: number): string => {
	if (x < 0 || x > width) return '0';
	if (y < 0 || y >= height) return '0';
	const string: string = input[y];
	return string[x];
}

let sum = 0;
let sumP2 = 0;
const visited: Array<Pos> = [];

const expandLine = (lines: Array<{positions: Array<Pos>, direction: number}>, direction: number, pos: Pos) => {
	const found = lines.find(l => l.direction === direction && l.positions.some(p => direction === horizontal ? p.y === pos.y : p.x === pos.x));
	if (found)
		found.positions.push(pos);
	else
		lines.push({positions: [pos], direction});
}

for (let y = 0; y < input.length; y++) {
	for (let x = 0; x < input[y].length; x++) {
		if (visited.includes(`X${x}Y${y}`)) continue;

		const stack: Array<Pos> = [{x, y}];
		const lines: Array<{positions: Array<Pos>, direction: number}> = [];
		let perimeter = 0;
		let area = 0;
		while (stack.length > 0) {
			const pos = stack.pop();
			if (visited.includes(`X${pos.x}Y${pos.y}`)) continue;
			const cur = getCell(pos.x, pos.y);
			area++;
			visited.push(`X${pos.x}Y${pos.y}`);
			const up = getCell(pos.x, pos.y - 1) === cur;
			const down = getCell(pos.x, pos.y + 1) === cur;
			const left = getCell(pos.x - 1, pos.y) === cur;
			const right = getCell(pos.x + 1, pos.y) === cur;
			if (!up) {
				perimeter++;
				expandLine(lines, horizontal, {x: pos.x, y: pos.y - 0.25});
			} else {
				stack.push({x: pos.x, y: pos.y - 1});
				if (!left) {
					expandLine(lines, vertical, {x: pos.x - 0.25, y: pos.y});
				}
				if (!right) {
					expandLine(lines, vertical, {x: pos.x + 0.25, y: pos.y});
				}
			}
			if (!left) {
				perimeter++;
				expandLine(lines, vertical, {x: pos.x - 0.25, y: pos.y});
			} else {
				stack.push({x: pos.x - 1, y: pos.y});
				if (!up) {
					expandLine(lines, horizontal, {x: pos.x, y: pos.y - 0.25});
				}
				if (!down) {
					expandLine(lines, horizontal, {x: pos.x, y: pos.y + 0.25});
				}
			}
			if (!down) {
				perimeter++;
				expandLine(lines, horizontal, {x: pos.x, y: pos.y + 0.25});
			} else {
				stack.push({x: pos.x, y: pos.y + 1});
				if (!left) {
					expandLine(lines, vertical, {x: pos.x - 0.25, y: pos.y});
				}
				if (!right) {
					expandLine(lines, vertical, {x: pos.x + 0.25, y: pos.y});
				}
			}
			if (!right) {
				perimeter++;
				expandLine(lines, vertical, {x: pos.x + 0.25, y: pos.y});
			} else {
				stack.push({x: pos.x + 1, y: pos.y});
				if (!up) {
					expandLine(lines, horizontal, {x: pos.x, y: pos.y - 0.25});
				}
				if (!down) {
					expandLine(lines, horizontal, {x: pos.x, y: pos.y + 0.25});
				}
			}
		}
		let totalLines = 0;
		lines.forEach(l => {
			totalLines++;
			const sorted = l.positions.toSorted((p1, p2) => {
				if (l.direction === vertical)
					return p1.y - p2.y;
				else
					return p1.x - p2.x;
			});
			let lastP = sorted[0];
			sorted.forEach(p => {
				if (l.direction === vertical) {
					if (Math.abs(lastP.y - p.y) > 1) totalLines++;
				} else {
					if (Math.abs(lastP.x - p.x) > 1) totalLines++;
				}
				lastP = p;
			});
		})
		sum += area * perimeter;
		sumP2 += area * totalLines;
		//console.log(`${input[y][x]} has ${area} area and ${totalLines} lines`);
	}
}

console.log('Solution part 1: ', sum);
console.log('Solution part 2: ', sumP2);
