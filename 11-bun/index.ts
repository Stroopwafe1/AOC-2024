if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();

let arr1 = content.split(' ').map(e => Number.parseInt(e));
const N = 25;

for (let i = 0; i < N; i++) {
	arr1 = arr1.flatMap(e => {
		if (e === 0) return 1;
		const str = e.toString();
		if (str.length % 2 === 0) {
			const middle = Math.floor(str.length / 2);
			return [
				Number.parseInt(str.substring(0, middle)),
				Number.parseInt(str.substring(middle))
			];
		}
		return e * 2024;
	});
}

console.log('Solution part 1: ', arr1.length);

let obj = {};
let nextObj = {};
content.split(' ').forEach(e => {
	obj[e] = 1;
});
const N2 = 75;

const incrementKey = (key: string, count: number) => {
	if (key in nextObj) {
		nextObj[key] += count;
	} else {
		nextObj[key] = (key in obj) ? obj[key] + count : count;
	}
}
const decrementKey = (key: string, count: number) => {
	if (key in nextObj)
		nextObj[key] -= count;
	else
		nextObj[key] = obj[key] - count;
}

for (let i = 0; i < N2; i++) {
	for (let key in obj) {
		const count = obj[key];
		decrementKey(key, count);
		if (key === '0') {
			incrementKey('1', count);
		} else if (key.length % 2 === 0) {
			const middle = Math.floor(key.length / 2);
			let key1 = Number.parseInt(key.substring(0, middle)).toString();
			incrementKey(key1, count);
			key1 = Number.parseInt(key.substring(middle)).toString();
			incrementKey(key1, count);
		} else {
			incrementKey((Number.parseInt(key) * 2024).toString(), count);
		}

	}
	obj = nextObj;
	nextObj = {};
}
let sum = 0;
for (let key in obj) {
	sum += obj[key];
}
console.log('Solution part 2: ', sum);
