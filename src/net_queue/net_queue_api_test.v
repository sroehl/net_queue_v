module net_queue

import time

fn testsuite_begin() {
	print_time("Starting listner")
	spawn start_server(4545)
	print_time("Listener done")
}

fn test_create_queue_api() {
	mut s := Server.new('localhost', 4545)
	resp := s.create_queue('testQueue') or {
		assert false
		return
	}
	assert resp.status == Status.success
	s.disconnect()
}

fn test_create_queue_already_error_api() {
	mut s := Server.new('localhost', 4545)
	queue_name := 'testAlreadyCreated'
	resp := s.create_queue(queue_name) or {
		assert false
		return
	}
	assert resp.status == Status.success
	resp2 := s.create_queue(queue_name) or {
		assert false
		return
	}
	assert resp2.status == Status.error
	s.disconnect()
}

fn test_delete_queue_api() {
	mut s := Server.new('localhost', 4545)
	queue_name := 'deleteQueueTest'
	create_resp := s.create_queue(queue_name) or {
		assert false
		return
	}
	assert create_resp.status == Status.success
	delete_resp := s.delete_queue(queue_name) or {
		assert false
		return
	}
	assert delete_resp.status == Status.success
}

fn test_delete_queue_does_not_exist_api() {
	mut s := Server.new('localhost', 4545)
	queue_name := 'deleteQueueNotExistTest'
	delete_resp := s.delete_queue(queue_name) or {
		assert false
		return
	}
	assert delete_resp.status == Status.error
}

fn test_list_queues_api() {
	mut s := Server.new('localhost', 4545)
	create_resp := s.create_queue("listQueue1") or {
		assert false
		return
	}
	assert create_resp.status == Status.success

	create_resp2 := s.create_queue("listQueue2") or {
		assert false
		return
	}
	assert create_resp2.status == Status.success
	list_resp := s.list_queues() or {
		assert false
		return
	}
	assert list_resp.status == Status.success
	assert list_resp.msg.contains("listQueue1,listQueue2")
}

// Following test cannot be completed until sending/receiving messages is complete
/*fn test_purge_queue_api() {
	mut s := Server.new('localhost', 4545)

}*/

/*fn test_exit_api() {
	print_time("Starting exit")
	mut s := Server.new('localhost', 4545)
	print_time("Server created")
	resp := s.exit() or {
		assert false
		return
	}
	assert resp.status == Status.success
	print_time("Exit complete")
	s.disconnect()
	assert false
}*/

fn print_time(msg string) {
	println("${time.now().unix_time()} - ${msg}")
}