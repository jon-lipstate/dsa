package singly_linked
//
import "core:intrinsics"
import "core:fmt"
has_field :: intrinsics.type_has_field

//example usage:
// main :: proc() {
// 	head: ^Node(int)
// 	sll_insert(&head, make_node(42))
// 	sll_insert(&head, make_node(13))
// 	sll_insert(&head, make_node(7))
// 	for node := head; node != nil; node = node.next {
// 		fmt.printf("%v, ", node.data)
// 	}
// 	sll_destroy(&head)
// 	fmt.println("end")
// }

Node :: struct(T: typeid) {
	next: ^Node(T),
	data: T,
}

make_node :: proc(val: $T, allocator := context.allocator) -> ^Node(T) {
	n := new(Node(T), allocator)
	n.data = val
	return n
}

sll_insert :: proc(head: ^^$T, node: ^T) where has_field(T, "next") {
	node.next = nil // guard for pulling off freelist
	if head^ != nil {node.next = head^}
	head^ = node
}

sll_append :: proc(prev: ^$T, node: ^T) where has_field(T, "next") {
	assert(prev != nil, "nil prev")
	prev.next = node
}

sll_remove :: proc(head: ^^$T) -> ^T where has_field(T, "next") {
	value: ^T
	if head^ != nil {
		value = head^
		head^ = value.next
		value.next = nil // guarding
	}
	return value
}

sll_destroy :: proc(head: ^^$T, allocator := context.allocator) where has_field(T, "next") {
	node: ^T = head^
	for node != nil {
		next := node.next
		err := free(node, allocator) // Note: Windows will not error on double free here, or give an error
		assert(err == .None, "Error on free()")
		node = next
	}
}
