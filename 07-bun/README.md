# Day 7: Bridge Repair

Today I am not feeling great with my head, so it's going to be solved in a very unoptimal manner.
The idea I had today was to follow a binary (or tertiary) representation of the number of possibilities

As binary naturally follows the possible options when you have two things it can be. (In our case a + or *)

Say you have 4 options, if you translate them all to binary you have an easy way to keep track of the brute force

- 00
- 01
- 10
- 11

If you imagine that 0 is + and 1 is *, then you can solve the problem

## Part 2

Part 2 follows the same principle, but using tertiary instead of binary so for 2 empty spots again you now actually have 3**2 = 9 possibilities

- 00
- 01
- 02
- 10
- 11
- 12
- 20
- 21
- 22

Where again 0 is +, 1 is *, and now 2 is ||
