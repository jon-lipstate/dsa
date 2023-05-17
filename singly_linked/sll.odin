package singly_linked
//
import "core:intrinsics"
has_field :: intrinsics.type_has_field

Node :: struct(T: typeid) {
	next: ^Node(T),
	data: T,
}
sll_insert :: proc(head: ^^$T, node: ^T) where has_field(T, "next") {
	node.next = nil
	if head^ == nil {head^ = node} else {
		node.next = head^
		head^ = node
	}
}
sll_append :: proc(prev: ^$T, node: ^T) where has_field(T, "next") {
	assert(prev != nil, "SLL: Nil-Append")
	prev.next = node
}
sll_remove :: proc(head: ^^$T) -> ^T where has_field(T, "next") {
	value: ^T
	if head^ != nil {
		value = head^
		head^ = value.next
		value.next = nil
	}
	return value
}
sll_destroy :: proc(head: ^^$T, allocator := context.allocator) where has_field(T, "next") {
	node: ^T = head^
	for node != nil {
		next := node.next
		err := free(node, allocator)
		assert(err == .None, "Deallocation Error")
		node = next
	}
}
