module main

import net_queue

fn main() {
	println("Starting listner")
	server_thread := spawn net_queue.start_server(4545)
	server_thread.wait()
	println("Listener done")
}
