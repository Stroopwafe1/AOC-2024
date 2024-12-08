if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = await file.text();

const input = content.split('\n');
input.pop();

type Pos = {x: number, y: number};
type AntennaGrid = Record<string, Array<Pos>>;
const grid: AntennaGrid = {};

let width = input[0].length;
let height = input.length;

input.forEach((line, y) => {
	for (let i = 0; i < line.length; i++) {
		if (line[i] === '.') {
			continue;
		}
		if (line[i] in grid) {
			grid[line[i]].push({x: i, y });
		} else {
			grid[line[i]] = [{x: i, y}];
		}
	}
});

const positions = {};

for (const key in grid) {
	const arr = grid[key as keyof AntennaGrid];
	arr.forEach((e, i) => {
		for (let j = 0; j < arr.length; j++) {
			if (i === j) continue;
			const f = arr[j];
			const dx = e.x - f.x;
			const dy = e.y - f.y;
			const newX = e.x + dx;
			const newY = e.y + dy;
			if (newX < 0 || newX >= width) continue;
			if (newY < 0 || newY >= height) continue;
			positions[`X${newX}Y${newY}`] = 1;
		}
	});
}

console.log('Solution part 1: ', Object.keys(positions).length);

for (const key in grid) {
	const arr = grid[key as keyof AntennaGrid];
	arr.forEach((e, i) => {
		positions[`X${e.x}Y${e.y}`] = 1;
		for (let j = 0; j < arr.length; j++) {
			if (i === j) continue;
			const f = arr[j];
			const dx = e.x - f.x;
			const dy = e.y - f.y;
			let newX = e.x + dx;
			let newY = e.y + dy;
			if (newX < 0 || newX >= width) continue;
			if (newY < 0 || newY >= height) continue;
			while (newX >= 0 && newX < width && newY >= 0 && newY < height) {
				positions[`X${newX}Y${newY}`] = 1;
				newX += dx;
				newY += dy;
			}
		}
	});
}

console.log('Solution part 2: ', Object.keys(positions).length);
