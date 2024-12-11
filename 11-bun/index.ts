if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = (await file.text()).trim();

const incrementKey = (obj: object, nextObj: object, key: string, count: number) => {
	if (key in nextObj) {
		nextObj[key] += count;
	} else {
		nextObj[key] = (key in obj) ? obj[key] + count : count;
	}
}
const decrementKey = (obj: object, nextObj: object, key: string, count: number) => {
	if (key in nextObj)
		nextObj[key] -= count;
	else
		nextObj[key] = obj[key] - count;
}

const solution = (part: number): number => {
	let obj = {};
	let nextObj = {};
	content.split(' ').forEach(e => {
		obj[e] = 1;
	});

	const N = part === 1 ? 25 : 75;
	let sum = 0;
	for (let i = 0; i < N; i++) {
		for (let key in obj) {
			const count = obj[key];
			decrementKey(obj, nextObj, key, count);
			if (key === '0') {
				incrementKey(obj, nextObj, '1', count);
			} else if (key.length % 2 === 0) {
				const middle = Math.floor(key.length / 2);
				let key1 = Number.parseInt(key.substring(0, middle)).toString();
				incrementKey(obj, nextObj, key1, count);
				key1 = Number.parseInt(key.substring(middle)).toString();
				incrementKey(obj, nextObj, key1, count);
			} else {
				incrementKey(obj, nextObj, (Number.parseInt(key) * 2024).toString(), count);
			}

		}
		obj = nextObj;
		nextObj = {};
	}

	for (let key in obj) {
		sum += obj[key];
	}
	return sum;
}

console.log('Solution part 1: ', solution(1));
console.log('Solution part 2: ', solution(2));
