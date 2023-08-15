module net_queue

import time

fn test_new_entry() {
	msg := "This is a test message"
	e := Entry.new(msg)
	assert e.msg == msg
	assert e.read == false
	assert e.time > time.now().unix_time()-1
}