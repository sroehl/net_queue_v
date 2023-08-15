module net_queue

enum CommandName {
	exit
	create_queue
	delete_queue
	purge_queue
	list_queues
	@none
}

// A hack which handles string to enum
// Update test with any new commands
fn CommandName.new(name string) CommandName {
	match name.to_lower() {
		'exit' {
			return .exit
		}
		'create_queue' {
			return .create_queue
		}
		'delete_queue' {
			return .delete_queue
		}
		'purge_queue' {
			return .purge_queue
		}
		'list_queues' {
			return .list_queues
		}
		else {
			return .@none
		}
	}
}



struct NetMessageCmd {
	command string
	arguments string
}

fn (cmd NetMessageCmd) handle_cmd(mut queues []Queue) NetReponse{
	println("handle_cmd ${cmd.command}")
	match CommandName.new(cmd.command) {
		.exit {
			exit(0)
		}
		.create_queue {
			queue_name := cmd.arguments.str()
			if !queue_exists(queue_name, queues) {
				queues << Queue.new(queue_name)
			} else {
				return NetReponse.new(Status.error, "Queue already exists")
			}
		}
		.delete_queue {
			queue_name := cmd.arguments.str()
			if queue_exists(queue_name, queues) {
				mut queue_idx := 0
				for i, queue in queues {
					if queue.name == queue_name {
						queue_idx = i
						break
					}
				}
				queues.delete(queue_idx)
			} else {
				return NetReponse.new(Status.error, "Queue does not exist")
			}
		}
		.purge_queue {
			// TODO: Purge queue
		}
		.list_queues {
			queue_names := queues.map(it.name).join(',')
			return NetReponse.new(Status.success, queue_names)
		}
		.@none {
			println("Unkonwn command")
		}
	}
	return NetReponse.new(Status.success, "")
}

fn queue_exists(queue_name string, queues []Queue) bool {
	return queues.filter(it.name == queue_name).len > 0
}