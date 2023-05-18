package stack
//
import "core:fmt"
import "core:builtin"
//

// // An explicit stack. Nominally you'd use [dynamic]T, but if behavior wants to be more explicit, this forces it.
// main :: proc() {
// 	s := Stack(int){};defer destroy(&s)
// 	push(&s, 42)
// 	push(&s, 84)
// 	fmt.println(pop(&s)) // 84, true
// 	fmt.println(pop(&s)) // 42, true
// 	fmt.println(pop(&s)) // 0, false
// }

// Stack :: struct(T: typeid) {
// 	s: [dynamic]T,
// }
// destroy :: proc(s: ^Stack($T)) {delete(s.s)}
// push :: proc(s: ^Stack($T), val: T) {append(&s.s, val)}
// pop :: proc(s: ^Stack($T)) -> (val: T, ok: bool) {
// 	if len(s.s) > 0 {
// 		val = builtin.pop(&s.s) // Notice we must prefix builtin, we have a naming collision
// 		ok = true
// 	}
// 	return
// }
// peek :: proc(s: ^Stack($T)) -> (val: T, ok: bool) {
// 	if len(s.s) > 0 {
// 		val = builtin.peek(&s.s)
// 		ok = true
// 	}
// 	return
// }
