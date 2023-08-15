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
	result := queues[0].read(false, false) or {
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