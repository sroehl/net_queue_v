module net_queue
import time

struct Entry {
	time i64
	msg string
	mut:
		read bool
}

fn Entry.new(msg string) Entry {
	return Entry{msg: msg
				 read: false
				 time: time.now().unix_time()
	}
}