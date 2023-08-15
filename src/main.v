module main

import net_queue

fn main() {
	mut queues := []net_queue.Queue{}
	println("Starting listner")
	net_queue.start_server(4545, mut &queues)
	println("Listener done")
}
