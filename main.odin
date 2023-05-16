package dsa
//
import "./stack"
import "core:fmt"
//
main :: proc() {
	s := stack.make_stack(int)
	stack.push(&s, 104)
	stack.push(&s, 1057)

	// drain me baby:
	for v in stack.pop(&s) {
		fmt.printf("%x", v)
	}
	stack.destroy_stack(&s)
	fmt.println("\nend")
}
