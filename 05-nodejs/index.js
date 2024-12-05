const fs = require('fs');

if (process.argv.length < 3) {
	console.error("Please provide an input file");
}

const fileName = process.argv[2];

try {
	const data = fs.readFileSync(fileName, 'utf8');
	let ruleString = data.split('\n\n')[0];
	let printString = data.split('\n\n')[1];
	const rules = new Map();

	ruleString.split('\n').map(e => e.split('|').map(i => Number.parseInt(i))).forEach(rule => {
		if (rules.has(rule[0])) {
			rules.get(rule[0]).push(rule[1]);
		} else {
			rules.set(rule[0], [rule[1]]);
		}
	});

	const prints = printString.split('\n').map(e => e.split(',').map(i => Number.parseInt(i)));
	prints.pop();

	const filteredP1 = prints.filter(print => {
		let returnVal = true;
		for (let i = 0; i < print.length; i++) {
			const num = print[i];
			const rule = rules.get(num);
			if (!rule) {
				continue;
			}
			const value = print.slice(0, i).some(p => rule.includes(p));
			if (value)
				returnVal = false;
		}
		return returnVal;
	});

	let sum = 0;
	filteredP1.forEach(f => {
		sum += f[Math.floor(f.length / 2)];
	});
	console.log("Sum part 1: ", sum);

	let filteredP2 = prints.filter(print => {
		let returnVal = false;
		for (let i = 0; i < print.length; i++) {
			const num = print[i];
			const rule = rules.get(num);
			if (!rule) {
				continue;
			}
			const value = print.slice(0, i).some(p => rule.includes(p));
			if (value)
				returnVal = true;
		}
		return returnVal;
	});

	filteredP2 = filteredP2.map(f => f.sort((a, b) => {
		const ruleA = rules.get(a);
		const ruleB = rules.get(b);
		if (ruleA?.includes(b)) {
			return -1;
		}
		if (ruleB?.includes(a)) {
			return 1;
		}
		return 0;
	}));

	sum = 0;
	filteredP2.forEach(f => {
		sum += f[Math.floor(f.length / 2)];
	});
	console.log("Sum part 2: ", sum);

} catch (err) {
	console.error(err);
}
