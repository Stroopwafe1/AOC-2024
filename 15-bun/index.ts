if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();
const mapStr = content.split('\n\n')[0];
const moveStr = content.split('\n\n')[1];

const width = mapStr.split('\n')[0].length;
const height = mapStr.split('\n').length;

const enum TileType {
	NONE = -1,
	EMPTY = 0,
	WALL = 1,
	BOX = 2,
}
type Vec2 = {
	x: number,
	y: number
}

const map: Aray<TileType> = [];
const robotPos: Vec2 = {x: 0, y: 0};
const parseMap = () => {
	let y = 0;
	let x = 0;
	Array.from(mapStr).forEach(c => {
		let resetX = false;
		if (c === '#')
			map.push(TileType.WALL);
		else if (c === '.')
			map.push(TileType.EMPTY);
		else if (c === 'O')
			map.push(TileType.BOX);
		else if (c === '@') {
			map.push(TileType.EMPTY);
			robotPos.x = x;
			robotPos.y = y;
		} else {
			x = 0;
			y++;
			resetX = true;
		}
		if (!resetX)
			x++;
	});
}

const getTile = (x: number, y: number) => {
	if (x < 0 || x >= width) return TileType.NONE;
	if (y < 0 || y >= height) return TileType.NONE;
	return map[y * width + x];
}

const setTile = (x: number, y: number, tile: TileType) => {
	map[y * width + x] = tile;
}

const displayMap = () => {
	let str = '';
	for (let y = 0; y < height; y++) {
		for (let x = 0; x < width; x++) {
			const tile = getTile(x, y);
			if (tile === TileType.BOX) {
				str += 'O';
			} else if (tile === TileType.WALL) {
				str += '#';
			} else if (tile === TileType.EMPTY) {
				if (robotPos.x === x && robotPos.y === y)
					str += '@';
				else
					str += '.';
			}
		}
		str += '\n';
	}
	console.log(str);
}

const doMove = (m: '^'|'<'|'v'|'>') => {
	if (m === '^') {
		const tile = getTile(robotPos.x, robotPos.y - 1);
		let canMove = true;
		if (tile === TileType.NONE) {
			console.error('Moved outside of area', robotPos);
			process.exit(1);
		} else if (tile === TileType.WALL) {
			// cannot move
			canMove = false;
		} else if (tile === TileType.BOX) {
			// keep looking in direction if there's more boxes
			let emptyY = 0;
			for (let i = 2; robotPos.y - i >= 0; i++) {
				const nextTile = getTile(robotPos.x, robotPos.y - i);
				if (nextTile === TileType.EMPTY) {
					emptyY = robotPos.y - i;
					break;
				} else if (nextTile === TileType.WALL) {
					emptyY = -1;
					break;
				}
			}
			if (emptyY > 0) {
				setTile(robotPos.x, emptyY, TileType.BOX);
				setTile(robotPos.x, robotPos.y - 1, TileType.EMPTY);
			} else {
				canMove = false;
			}
		}
		if (canMove) {
			robotPos.y -= 1;
		}
	} else if (m === 'v') {
		const tile = getTile(robotPos.x, robotPos.y + 1);
		let canMove = true;
		if (tile === TileType.NONE) {
			console.error('Moved outside of area', robotPos);
			process.exit(1);
		} else if (tile === TileType.WALL) {
			// cannot move
			canMove = false;
		} else if (tile === TileType.BOX) {
			// keep looking in direction if there's more boxes
			let emptyY = 0;
			for (let i = 2; robotPos.y + i < height; i++) {
				const nextTile = getTile(robotPos.x, robotPos.y + i);
				if (nextTile === TileType.EMPTY) {
					emptyY = robotPos.y + i;
					break;
				} else if (nextTile === TileType.WALL) {
					emptyY = -1;
					break;
				}
			}
			if (emptyY > 0) {
				setTile(robotPos.x, emptyY, TileType.BOX);
				setTile(robotPos.x, robotPos.y + 1, TileType.EMPTY);
			} else {
				canMove = false;
			}
		}
		if (canMove) {
			robotPos.y += 1;
		}
	} else if (m === '<') {
		const tile = getTile(robotPos.x - 1, robotPos.y);
		let canMove = true;
		if (tile === TileType.NONE) {
			console.error('Moved outside of area', robotPos);
			process.exit(1);
		} else if (tile === TileType.WALL) {
			// cannot move
			canMove = false;
		} else if (tile === TileType.BOX) {
			// keep looking in direction if there's more boxes
			let emptyX = 0;
			for (let i = 2; robotPos.x - i >= 0; i++) {
				const nextTile = getTile(robotPos.x - i, robotPos.y);
				if (nextTile === TileType.EMPTY) {
					emptyX = robotPos.x - i;
					break;
				} else if (nextTile === TileType.WALL) {
					emptyX = -1;
					break;
				}
			}
			if (emptyX > 0) {
				setTile(emptyX, robotPos.y, TileType.BOX);
				setTile(robotPos.x - 1, robotPos.y, TileType.EMPTY);
			} else {
				canMove = false;
			}
		}
		if (canMove) {
			robotPos.x -= 1;
		}
	} else if (m === '>') {
		const tile = getTile(robotPos.x + 1, robotPos.y);
		let canMove = true;
		if (tile === TileType.NONE) {
			console.error('Moved outside of area', robotPos);
			process.exit(1);
		} else if (tile === TileType.WALL) {
			// cannot move
			canMove = false;
		} else if (tile === TileType.BOX) {
			// keep looking in direction if there's more boxes
			let emptyX = 0;
			for (let i = 2; robotPos.x + i < width; i++) {
				const nextTile = getTile(robotPos.x + i, robotPos.y);
				if (nextTile === TileType.EMPTY) {
					emptyX = robotPos.x + i;
					break;
				} else if (nextTile === TileType.WALL) {
					emptyX = -1;
					break;
				}
			}
			if (emptyX > 0) {
				setTile(emptyX, robotPos.y, TileType.BOX);
				setTile(robotPos.x + 1, robotPos.y, TileType.EMPTY);
			} else {
				canMove = false;
			}
		}
		if (canMove) {
			robotPos.x += 1;
		}
	}
}


const calculateSum = () => {
	let sum = 0;
	for (let y = 0; y < height; y++) {
		for (let x = 0; x < width; x++) {
			const tile = getTile(x, y);
			if (tile === TileType.BOX) {
				sum += y * 100 + x;
			}
		}
	}
	return sum;
}

const simulate = () => {
	Array.from(moveStr).forEach(c => {
		doMove(c);
		displayMap();
	})
}
parseMap();
displayMap();
simulate();
displayMap();
const sumP1 = calculateSum();
console.log('Sum part 1: ', sumP1);
