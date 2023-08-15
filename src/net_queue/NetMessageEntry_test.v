module net_queue

fn test_write_entry() {
	queue_name := "testQueue"
	mut queues := []Queue{}
	queues << Queue.new(queue_name)
	net_entry := NetMessageEntry{queue: queue_name
							msg: "Test message"
							}
	resp1 := net_entry.write_entry(mut queues)
	assert resp1.status == Status.success
	assert queues[0].size == 1
	net_entry2 := NetMessageEntry{queue: "BadQueue"
							msg: "Test message"
							}
	resp2 := net_entry2.write_entry(mut queues)
	assert resp2.status == Status.error
	assert resp2.msg == "Queue does not exist"
}

fn test_read_entry() {
	queue_name := "testQueue"
	mut queues := []Queue{}
	queues << Queue.new(queue_name)
	queues[0].add("Test message")
	assert queues[0].size == 1
	result := queues[0].read(false, false, 0) or {
		assert false
		return
	}
	assert queues[0].size == 1
	assert result.entry.msg == "Test message"
	net_entry := NetMessageEntry{queue: queue_name}
	resp := net_entry.read_entry(mut queues)
	println(resp.msg)
	assert resp.status == Status.success
	assert resp.msg == "Test message"
}

fn test_read_many() {
	queue_name := "testQueue"
	mut queues := []Queue{}
	mut found := 0
	queues << Queue.new(queue_name)
	queues[0].add("Test message1")
	queues[0].add("Test message2")
	queues[0].add("Test message3")
	queues[0].add("Test message4")
	assert queues[0].size == 4
	net_entry := NetMessageEntry{queue: queue_name}
	resp := net_entry.read_entry(mut queues)
	found++
	mut has_more := resp.status == Status.has_more
	mut idx := resp.index
	for has_more {
		net_entry2 := NetMessageEntry{queue: queue_name
									 index: idx+1}
		resp2 := net_entry2.read_entry(mut queues)
		if idx+1 < 3 {
			assert resp2.status == Status.has_more
			assert resp2.index == idx+1
		}
		if idx+1 == 4 {
			assert resp2.status == Status.success
			assert resp2.index == 4
		}
		if resp2.status == Status.success || resp2.status == Status.has_more {
			found++
		}
		has_more = resp2.status == Status.has_more
		idx = resp2.index
	}
	assert found == 4
}