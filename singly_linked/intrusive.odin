package singly_linked
import "core:fmt"
//

//example usage:
// main :: proc() {
// 	head: ^Data
// 	insert_data(&head, 42)
// 	insert_data(&head, 13)
// 	insert_data(&head, 7)
// 	fmt.println(find(head, 13)) // &Data{node = Link{next = 0x18FC0C8E968}, data = 13}
// }

Link :: struct {
	next: ^Link,
}

Data :: struct {
	using node: Link,
	data:       int,
}

insert_data :: proc(head: ^^Data, val: int, allocator := context.allocator) -> ^Data {
	d := new(Data, allocator)
	d.data = val
	if head^ != nil {d.next = &(head^).node}
	head^ = d
	return d
}

find :: proc(start: ^Data, val: int) -> ^Data {
	for node := &start.node; node != nil; node = node.next {
		d := container_of(node, Data, "node")
		if d.data == val {return d}
	}
	return nil
}
