module net_queue

fn test_get_queue() {
	assert CommandName.exit.str() == 'exit'
	assert CommandName.new('EXIT') == CommandName.exit
	assert CommandName.new('CREATE_QUEUE') == CommandName.create_queue
	assert CommandName.new('DELETE_QUEUE') == CommandName.delete_queue
	assert CommandName.new('PURGE_QUEUE') == CommandName.purge_queue
	assert CommandName.new('LIST_QUEUES') == CommandName.list_queues
	assert CommandName.new('UNKNOWN_BAD') == CommandName.@none
}

fn test_create_queue() {
	mut queues := []Queue{}
	net_cmd := NetMessageCmd{command: "create_queue"
							arguments: "testQueue"
							}
	resp1 := net_cmd.handle_cmd(mut queues)
	assert resp1.status == Status.success
	resp2 := net_cmd.handle_cmd(mut queues)
	assert resp2.status == Status.error
	assert resp2.msg == 'Queue already exists'
	assert queues.len == 1
}

fn test_delete_queue() {
	queue_name := 'testQueue'
	mut queues := []Queue{}
	queues << Queue.new("testQueue0")
	queues << Queue.new(queue_name)
	queues << Queue.new("testQueue2")
	net_cmd := NetMessageCmd{command: "delete_queue"
							arguments: queue_name
							}
	resp1 := net_cmd.handle_cmd(mut queues)
	assert resp1.status == Status.success
	resp2 := net_cmd.handle_cmd(mut queues)
	assert resp2.status == Status.error
	assert resp2.msg == 'Queue does not exist'
	assert queues.len == 2
}

fn test_list_queues() {
	mut queues := []Queue{}
	net_cmd := NetMessageCmd{command: "list_queues"
							}
	queues << Queue.new("testQueue0")
	resp1 := net_cmd.handle_cmd(mut queues)
	assert resp1.status == Status.success
	assert resp1.msg.split(',').len == 1
	queues << Queue.new("testQueue1")
	resp2 := net_cmd.handle_cmd(mut queues)
	assert resp2.status == Status.success
	assert resp2.msg.split(',').len == 2
}