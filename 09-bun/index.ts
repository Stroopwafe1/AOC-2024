if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();

let isFile = true;
const output = [];
let metadata = {};
let free = [];
let highestID = 0;
for (let i = 0, id = 0; i < content.length; i++) {
	const c = content[i];
	const num = Number.parseInt(c);
	if (isFile) {
		metadata[id] = {
			index: output.length,
			length: num
		};
		for (let j = 0; j < num; j++) {
			output.push(id);
		}
		highestID = id;
		id++;
	} else {
		if (num !== 0) {
			free.push({index: output.length, length: num});
			for (let j = 0; j < num; j++) {
				output.push('.');
			}
		}
	}
	isFile = !isFile;
}

// How did this work?
for (let i = 0; i < output.length; i++) {
	let back = output.length - 1 - i;
	while (output[back] === '.') {
		back--;
	}
	const index = output.indexOf('.');
	if (index > back) break;
	output[index] = output[back];
	output[back] = '.';
}
console.log('Solution part 1: ', output.filter(c => c !== '.').reduce((acc, cur, idx) => acc + idx * cur, 0))


// Part 2
let id = highestID;
while (id >= 0) {
	free = free.sort((a, b) => a.index - b.index);
	const meta = metadata[id];
	for (let i = 0; i < free.length; i++) {
		if (free[i].index > meta.index) break;
		if (meta.length <= free[i].length) {
			free.push({index: meta.index, length: meta.length});
			meta.index = free[i].index;
			free[i].length -= meta.length;
			free[i].index += meta.length;
			if (free[i].length === 0)
				free.splice(i, 1);
			break;
		}
	}
	id--;
}

let sum = 0;
for (const key in metadata) {
	const meta = metadata[key];
	for (let i = 0; i < meta.length; i++) {
		sum += (meta.index + i) * key;
	}
}
console.log('Solution part 2: ', sum);
