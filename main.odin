package dsa
//
import "./stack"
import "./queue"
import "core:fmt"
//
main :: proc() {
	q := queue.make_queue(int, 2)
	queue.enqueue(&q, 0xf1)
	queue.enqueue(&q, 0xf0)
	queue.enqueue(&q, 0xc0)
	queue.enqueue(&q, 0xde)
	for v in queue.dequeue(&q) {
		fmt.printf("%x", v)
	}
	queue.destroy_queue(&q)
	fmt.println("\ndone")
}
