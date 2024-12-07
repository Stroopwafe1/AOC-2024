if (process.argv.length === 2) {
	console.error("Please provide an input file");
	process.exit(1);
}
const file = Bun.file(process.argv[2]);
const content = await file.text();

const arr = content
				.split('\n')
				.map(e => [
					Number.parseInt(e.split(':')[0]),
					e.split(':')[1]
						?.trim()
						?.split(' ')
						.map(f => Number.parseInt(f))
				]);
arr.pop();

// arr is Array[Array[value, Array[input]]]
const filtered = arr.filter(a => {
	for (let i = 0; i < 2**(a[1].length - 1); i++) {
		let acc = 0;
		const bins = i.toString(2).padStart((2**(a[1].length - 1)).toString(2).length - 1, '0').split('');
		for (let j = 0, g = 0; j < bins.length; j++, g++) {
			const val1 = a[1][g];
			if (j === 0) {
				const val2 = a[1][1];
				acc = bins[j] === '0' ? val1 + val2 : val1 * val2;
				g += 1;
			} else {
				acc = bins[j] === '0' ? acc + val1 : acc * val1;
			}
		}
		if (acc === a[0]) {
			return true;
		}

	}
	return false;
});

console.log("Solution part 1: ", filtered.reduce((acc, cur) => acc + cur[0], 0));

const filteredP2 = arr.filter(a => {
	for (let i = 0; i < 3**(a[1].length - 1); i++) {
		let acc = 0;
		const bins = i.toString(3).padStart((3**(a[1].length - 1)).toString(3).length - 1, '0').split('');
		for (let j = 0, g = 0; j < bins.length; j++, g++) {
			const val1 = a[1][g];
			if (j === 0) {
				const val2 = a[1][1];
				if (bins[j] === '0') {
					acc = val1 + val2;
				} else if (bins[j] === '1') {
					acc = val1 * val2;
				} else {
					acc = Number.parseInt(`${val1}` + `${val2}`);
				}
				g += 1;
			} else {
				if (bins[j] === '0') {
					acc = acc + val1;
				} else if (bins[j] === '1') {
					acc = acc * val1;
				} else {
					acc = Number.parseInt(`${acc}` + `${val1}`);
				}
			}
		}
		if (acc === a[0]) {
			return true;
		}

	}
	return false;
});
console.log("Solution part 2: ", filteredP2.reduce((acc, cur) => acc + cur[0], 0));
