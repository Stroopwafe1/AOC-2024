if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();
const input = content.split('\n');

const width = process.argv[2] === 'sample.txt' ? 11 : 101;
const height = process.argv[2] === 'sample.txt' ? 7 : 103;

type Vec2 = {x: number, y: number};
type Robot = {
	pos: Vec2,
	vel: Vec2
};

Number.prototype.mod = function (n) {
	"use strict";
	return ((this % n) + n) % n;
};

const robots: Array<Robot> = [];
const parseRobots = () => {
	input.forEach(i => {
		const posStr = i.split(' ')[0].substr(2);
		const velStr = i.split(' ')[1].substr(2);
		const robot = {
			pos: {
				x: Number.parseInt(posStr.split(',')[0]),
				y: Number.parseInt(posStr.split(',')[1]),
			},
			vel: {
				x: Number.parseInt(velStr.split(',')[0]),
				y: Number.parseInt(velStr.split(',')[1]),
			}
		}
		robots.push(robot);
	});
}
parseRobots();

const writePPM = (step: number) => {
	const outputFile = Bun.file(`${step}.ppm`);
	const data = new Uint8Array(width * height * 3);
	const writer = outputFile.writer();
	writer.write(`P6 ${width} ${height} 255`);

	robots.forEach(robot => {
		const index = (robot.pos.y * width + (robot.pos.x)) * 3;
		data[index] = 0;
		data[index + 1] = 0;
		data[index + 2] = 255;
	});

	writer.write(data);
	writer.end();
}

const simulate = (steps: number) => {
	robots.forEach(robot => {
		robot.pos.x = (robot.pos.x + robot.vel.x * steps).mod(width);
		robot.pos.y = (robot.pos.y + robot.vel.y * steps).mod(height);
	});
}
// Part1
//simulate(100);

const quadrate = () => {
	const quadrants = [0, 0, 0, 0];
	const middleX = Math.floor(width / 2.0);
	const middleY = Math.floor(height / 2.0);
	robots.forEach(robot => {
		if (robot.pos.x < middleX) {
			if (robot.pos.y < middleY) {
				quadrants[0]++;
			} else if (robot.pos.y > middleY) {
				quadrants[2]++;
			}
		} else if (robot.pos.x > middleX) {
			if (robot.pos.y < middleY) {
				quadrants[1]++;
			} else if (robot.pos.y > middleY) {
				quadrants[3]++;
			}
		}
	});
	const safety = quadrants.reduce((acc, cur) => acc * cur);
	console.log('Safety factor is ', safety);
}
//quadrate();


for (let i = 1; i < 10000; i++) {
	simulate(1);
	const hasAllNbors = robots.some((robot) => {
		const up = robots.some(r => r.pos.x === robot.pos.x && r.pos.y === robot.pos.y - 1);
		const down = robots.some(r => r.pos.x === robot.pos.x && r.pos.y === robot.pos.y + 1);
		const left = robots.some(r => r.pos.x === robot.pos.x - 1 && r.pos.y === robot.pos.y);
		const right = robots.some(r => r.pos.x === robot.pos.x + 1 && r.pos.y === robot.pos.y);
		return (up && down) && (left && right);
	});
	if (hasAllNbors)
		writePPM(i);
}
