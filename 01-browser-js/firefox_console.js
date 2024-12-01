// Setup
let arr1 = temp0.textContent.split('\n').map(e => Number.parseInt(e.split('   ')[0]))
let arr2 = temp0.textContent.split('\n').map(e => Number.parseInt(e.split('   ')[1]))
arr1.sort();
arr2.sort();
arr1.pop();
arr2.pop();
let total = 0;

// part 1
total = 0; for (let i = 0; i < arr1.length; i++) { total += Math.abs(arr1[i] - arr2[i]); }; console.log(total);

// part2
total = 0; for (let i = 0; i < arr1.length; i++) { let needle = arr1[i]; total += arr2.filter(e => e === needle).length * needle }; console.log(total)
