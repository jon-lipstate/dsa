package stack
import "core:runtime"
import "core:intrinsics"
has_field :: intrinsics.type_has_field
//
Stack :: struct(T: typeid) {
	head:      ^Node(T),
	freelist:  ^Node(T),
	allocator: runtime.Allocator,
}

Node :: struct(T: typeid) {
	next: ^Node(T),
	data: T,
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
	head: ^Node(T)
	if s.freelist != nil {
		head = s.freelist
		s.freelist = head.next
	} else {
		err: runtime.Allocator_Error
		head, err = new(Node(T), s.allocator)
		if err != .None {return false}
	}
	head.data = elm
	sll_insert(&s.head, head)
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

sll_insert :: proc(head: ^^$T, node: ^T) where has_field(T, "next") {
	if head^ == nil {head^ = node} else {
		node.next = head^
		head^ = node
	}
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
		free(node, allocator)
		node = next
	}
}
