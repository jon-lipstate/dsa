package stack
//
import "core:runtime"
import "../singly_linked"
Node :: singly_linked.Node
sll_insert :: singly_linked.sll_insert
sll_remove :: singly_linked.sll_remove
sll_destroy :: singly_linked.sll_destroy
//
// import "./stack"
// import "core:fmt"
// //
// main :: proc() {
// 	s := stack.make_stack(int)
// 	stack.push(&s, 104)
// 	stack.push(&s, 1057)

// 	// drain me:
// 	for v in stack.pop(&s) {
// 		fmt.printf("%x", v)
// 	}
// 	stack.destroy_stack(&s)
// 	fmt.println("\nend")
// }
//
Stack :: struct(T: typeid) {
	head:      ^Node(T),
	freelist:  ^Node(T),
	allocator: runtime.Allocator,
}

make_stack :: proc(
	$T: typeid,
	n_elm: int = 0,
	allocator := context.allocator,
) -> (
	s: Stack(T),
	ok: bool,
) #optional_ok {
	s = Stack(T) {
		allocator = allocator,
	}
	// Pre-Allocate Elements:
	for i in 0 ..= n_elm {
		n, err := new(Node(T), allocator)
		if err != .None {
			ok = false
			break
		}
		if s.freelist == nil {s.freelist = n} else {n.next = s.freelist;s.freelist = n}
	}
	ok = true
	return
}
destroy_stack :: proc(s: ^Stack($T)) {
	sll_destroy(&s.head)
	sll_destroy(&s.freelist)
}

push :: proc(s: ^Stack($T), elm: T) -> (ok: bool) {
	node: ^Node(T)
	if s.freelist != nil {
		node = s.freelist
		s.freelist = node.next
		node.next = nil
	} else {
		err: runtime.Allocator_Error
		node, err = new(Node(T), s.allocator)
		if err != .None {return false}
	}
	node.data = elm
	sll_insert(&s.head, node)
	return true
}
pop :: proc(s: ^Stack($T)) -> (v: T, ok: bool) {
	n := sll_remove(&s.head)
	if n == nil {ok = false} else {
		v = n.data
		ok = true
		sll_insert(&s.freelist, n)
	}
	return
}
peek :: proc(s: ^Stack($T)) -> (v: T, ok: bool) {
	if s.head == nil {ok = false} else {
		v = s.head.data
		ok = true
	}
	return
}
