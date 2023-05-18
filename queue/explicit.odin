package queue
// //
// import "core:fmt"
// import "core:builtin"
// //

// // An explicit Queue. Nominally you'd use [dynamic]T, but if behavior wants to be more explicit, this forces it.
// main :: proc() {
// 	q := Queue(int){};defer destroy(&q)
// 	enqueue(&q, 42)
// 	enqueue(&q, 84)
// 	fmt.println(dequeue(&q)) // 42, true
// 	fmt.println(dequeue(&q)) // 84, true
// 	fmt.println(dequeue(&q)) // 0, false
// }

// Queue :: struct(T: typeid) {
// 	q: [dynamic]T,
// }
// destroy :: proc(q: ^Queue($T)) {delete(q.q)}
// enqueue :: proc(q: ^Queue($T), val: T) {append(&q.q, val)}
// dequeue :: proc(q: ^Queue($T)) -> (val: T, ok: bool) {
// 	if len(q.q) > 0 {
// 		val = pop_front(&q.q)
// 		ok = true
// 	}
// 	return
// }
// peek :: proc(s: ^Queue($T)) -> (val: T, ok: bool) {
// 	if len(s.s) > 0 {
// 		val = builtin.peek(&q.s) // Notice we must prefix builtin, we have a naming collision
// 		ok = true
// 	}
// 	return
// }
