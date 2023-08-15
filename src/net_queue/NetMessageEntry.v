module net_queue



struct NetMessageEntry {
	queue string
	msg string
	index int = 0
}


fn (entry NetMessageEntry) write_entry(mut queues []Queue) NetReponse {
	for i, queue in queues {
		if queue.name == entry.queue {
			queues[i].add(entry.msg)
			return NetReponse.new(Status.success, "")
		} else {
			return NetReponse.new(Status.error, "Queue does not exist")
		}
	}
}

fn (entry NetMessageEntry) read_entry(mut queues []Queue) NetReponse {
		for i, queue in queues {
		if queue.name == entry.queue {
			result := queues[i].read(false, false, entry.index) or {
				println("Here")
				return NetReponse.new(Status.error, "Error: " + err.str())
			}
			mut status := Status.success
			if result.has_more {
				status = Status.has_more
			}	
			mut resp := NetReponse.new(status, result.entry.msg)
			if result.index > -1 {
				resp.index = result.index
			}
			return resp
		} else {
			return NetReponse.new(Status.error, "Queue does not exist")
		}
	}
}