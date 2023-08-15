module net_queue

fn create_queue(num_msgs int) Queue {
	mut queue := Queue.new("TestQueue1")
	for i in 1 .. num_msgs + 1 {
		msg := "Test msg num:${i}"
		queue.add(msg)
	}
	return queue
}

fn test_queue_creation() {
	queue_name := "TestQueue1"
	queue := Queue.new(queue_name)
	assert queue.name == queue_name
	assert queue.size == 0
}

fn test_queue_add() {
	mut queue := create_queue(3)
	assert queue.size == 3
	assert queue.entries[0].msg == "Test msg num:1"
	assert queue.entries[0].read == false
	assert queue.entries[1].msg == "Test msg num:2"
	assert queue.entries[1].read == false
}

fn test_queue_read_unread_no_remove() {
	mut queue := create_queue(5)
	result := queue.read(false, false) or {
		assert false
		return
	}
	assert result.entry.msg == "Test msg num:1"
	assert result.has_more == true
	assert queue.size == 5
	result2 := queue.read(false, false) or {
		assert false
		return
	}
	assert result2.entry.msg == "Test msg num:1"
	assert result2.has_more == true
	assert queue.size == 5
}

fn test_queue_read_unread_remove() {
	mut queue := create_queue(5)
	result:= queue.read(false, true) or {
		assert false
		return
	}
	assert result.entry.msg == "Test msg num:1"
	assert result.has_more == true
	assert queue.size == 4
	result2 := queue.read(false, true) or {
		assert false
		return
	}
	assert result2.entry.msg == "Test msg num:2"
	assert result2.has_more == true
	assert queue.size == 3
}

fn test_queue_read_already_read_no_remove() {
	mut queue := create_queue(5)
	result := queue.read(true, false) or {
		assert false
		return
	}
	assert result.entry.msg == "Test msg num:1"
	assert result.has_more == true
	assert queue.size == 5
	result2 := queue.read(true, false) or {
		assert false
		return
	}
	assert result2.entry.msg == "Test msg num:2"
	assert result2.has_more == true
	assert queue.size == 5
}

fn test_queue_read_already_read_remove() {
	mut queue := create_queue(5)
	result := queue.read(true, true) or {
		assert false
		return
	}
	assert result.entry.msg == "Test msg num:1"
	assert result.has_more == true
	assert queue.size == 4
	result2 := queue.read(true, true) or {
		assert false
		return
	}
	assert result2.entry.msg == "Test msg num:2"
	assert result2.has_more == true
	assert queue.size == 3
}

fn test_queue_read_0_entries() {
	mut queue := create_queue(0)
	result := queue.read(false, false)
	assert result == none
}