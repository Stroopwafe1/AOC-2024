if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();
const input: Array<Array<string>> = content.split('\n\n').map(i => i.split('\n'));
//console.log(input);

type Pos = {x: number, y: number};
type Configuration = {
	a: {
		x: number,
		y: number
	},
	b: {
		x: number,
		y: number
	},
	prize: {
		x: number,
		y: number
	}
}

const configurations: Array<Configuration> = [];

const parseConfigs = () => {
	input.forEach(i => {
		const config: Configuration = {
			a: {x: 0, y: 0},
			b: {x: 0, y: 0},
			prize: {x: 0, y: 0}
		};
		const a = i[0];
		const b = i[1];
		const prize = i[2];
		a.split(': ')[1].split(', ').forEach((blep, idx) => {
			if (idx === 0)
				config.a.x = Number.parseInt(blep.split('+')[1]);
			else
				config.a.y = Number.parseInt(blep.split('+')[1]);
		});
		b.split(': ')[1].split(', ').forEach((blep, idx) => {
			if (idx === 0)
				config.b.x = Number.parseInt(blep.split('+')[1]);
			else
				config.b.y = Number.parseInt(blep.split('+')[1]);
		});
		prize.split(': ')[1].split(', ').forEach((blep, idx) => {
			if (idx === 0)
				config.prize.x = Number.parseInt(blep.split('=')[1]);
			else
				config.prize.y = Number.parseInt(blep.split('=')[1]);
		});
		configurations.push(config);
	});
}
parseConfigs();

const part1Bruteforce = () => {
	let sum = 0;
	const solutions = [];
	configurations.forEach((config, idx) => {
		for (let a = 1; a < 100; a++) {
			for (let b = 1; b < 100; b++) {
				if (a * config.a.x + b * config.b.x === config.prize.x &&
					a * config.a.y + b * config.b.y === config.prize.y
				) {
					console.log(`A: ${a}, B: ${b}`);
					if (solutions.length <= idx) {
						solutions.push([3 * a + b]);
					} else {
						solutions[idx].push(3 * a + b);
					}
				}
			}
		}
	});
	solutions.forEach(s => {
		sum += Math.min(...s);
	});
	console.log('Solution part 1: ', sum);
}
part1Bruteforce();


const part1Nice = () => {
	let sum = 0;
	const solutions = [];
	configurations.forEach((config, idx) => {
		const ab = -config.b.x / config.a.x;
		const aprize = config.prize.x / config.a.x;

		const b2 = config.a.y * ab + config.b.y;
		const prize2 = config.prize.y - config.a.y * aprize;
		const b = Math.round(prize2 / b2);

		const a = ab * b + aprize;

		if ((a % 1 <= .01 || a % 1 >= 0.97) && a > 0 && a < 100 && b > 0 && b < 100) {
			console.log(`A: ${Math.round(a)}, B: ${b}`);
			solutions.push(Math.round(a) * 3 + b);
		}
	});
	sum = solutions.reduce((acc, cur) => acc + cur, 0);
	console.log('Solution part 1: ', sum);
}
part1Nice();

const part2Nice = () => {
	let sum = 0;
	const solutions = [];
	const newConfigs = configurations.map(c => {
		return {
			a: c.a,
			b: c.b,
			prize: {
				x: c.prize.x + 10000000000000,
				y: c.prize.y + 10000000000000
			}
		};
	});
	newConfigs.forEach((config, idx) => {
		const ab = -config.b.x / config.a.x;
		const aprize = config.prize.x / config.a.x;

		const b2 = config.a.y * ab + config.b.y;
		const prize2 = config.prize.y - config.a.y * aprize;
		const b = Math.round(prize2 / b2);

		const a = ab * b + aprize;

		if ((a % 1 <= .01 || a % 1 >= 0.99) && a > 0 && b > 0) {
			if (Math.round(a) * config.a.x + b * config.b.x === config.prize.x &&
				Math.round(a) * config.a.y + b * config.b.y === config.prize.y
			) {
				console.log(`Index: ${idx}, A: ${Math.round(a)}, B: ${b}`);
				solutions.push(Math.round(a) * 3 + b);
			}
		}
	});
	sum = solutions.reduce((acc, cur) => acc + cur, 0);
	console.log('Solution part 2: ', sum);
}
part2Nice();
