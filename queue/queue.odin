package queue

import "core:runtime"
import "../singly_linked"
Node :: singly_linked.Node
sll_insert :: singly_linked.sll_insert
sll_remove :: singly_linked.sll_remove
sll_destroy :: singly_linked.sll_destroy

// example:
import "core:fmt"
//
main :: proc() {
	q := make_queue(int, 2)
	enqueue(&q, 0xf1)
	enqueue(&q, 0xf0)
	enqueue(&q, 0xc0)
	enqueue(&q, 0xde)
	for v in dequeue(&q) {
		fmt.printf("%x", v)
	}
	destroy_queue(&q)
	fmt.println("\ndone")
}

Queue :: struct(T: typeid) {
	head:      ^Node(T),
	tail:      ^Node(T),
	freelist:  ^Node(T),
	allocator: runtime.Allocator,
}
make_queue :: proc(
	$T: typeid,
	n_elm: int = 0,
	allocator := context.allocator,
) -> (
	q: Queue(T),
	ok: bool,
) #optional_ok {
	q = Queue(T) {
		allocator = allocator,
	}
	for i in 0 ..< n_elm {
		n, err := new(Node(T), allocator)
		if err != .None {
			ok = false
			break
		}
		if q.freelist == nil {q.freelist = n} else {n.next = q.freelist;q.freelist = n}
	}
	ok = true
	return
}
destroy_queue :: proc(q: ^Queue($T)) {
	sll_destroy(&q.head)
	// do not destroy the tail, same chain as head
	sll_destroy(&q.freelist)
}

enqueue :: proc(q: ^Queue($T), elm: T) -> (ok: bool) {
	node: ^Node(T)
	if q.freelist != nil {
		node = q.freelist
		q.freelist = node.next
		node.next = nil
	} else {
		err: runtime.Allocator_Error
		node, err = new(Node(T), q.allocator)
		if err != .None {return false}
	}
	node.data = elm
	if q.tail == nil {
		q.head = node
		q.tail = node
	} else {
		q.tail.next = node
		q.tail = node
	}
	return true
}

dequeue :: proc(q: ^Queue($T)) -> (v: T, ok: bool) {
	n := sll_remove(&q.head)
	if q.head == nil {q.tail = nil} 	// clear the tail when empty
	if n == nil {ok = false} else {
		v = n.data
		ok = true
		sll_insert(&q.freelist, n)
	}
	return
}

peek :: proc(q: ^Queue($T)) -> (v: T, ok: bool) {
	if q.head == nil {ok = false} else {
		v = q.head.data
		ok = true
	}
	return
}
