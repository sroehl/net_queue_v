module net_queue

pub struct Queue {
	name string
	mut:
		entries []Entry
		size int
}

fn Queue.new(name string) Queue {
	return Queue{name: name}
}

fn (mut q Queue) add(msg string) {
	e := Entry.new(msg)
	q.entries << e
	q.size++
}

struct EntryResult {
	entry Entry
	has_more bool
	index int
}

fn EntryResult.new(entry Entry, has_more bool, index int) EntryResult {
	if index > -1 {
		return EntryResult{entry: entry
						has_more: has_more
						index: index
						}
	} else {
		return EntryResult{entry: entry
						has_more: has_more
						}
	}
}


fn (mut q Queue) read(unread bool, remove bool, starting_idx int) ?EntryResult{
	if q.size == 0 || starting_idx >= q.size {
		return none
	}
	mut has_more := false
	mut e := Entry{}
	mut idx := -1
	if !unread {
		q.entries[starting_idx].read = true
		e = q.entries[starting_idx]
		idx = starting_idx
		if q.entries.len > starting_idx+1 {
			has_more = true
		}
	} else {
		for i in starting_idx .. q.size {
			if !q.entries[i].read {
				if idx == -1 {
					q.entries[i].read = true
					e = q.entries[i]
					idx = i
				} else {
					// Look for additional entries to set has_more flag
					has_more = true
					break
				}
			}
		}
	}
	if idx == -1 {
		return none
	}
	if remove {
		q.entries.delete(idx)
		q.size--
	}
	return EntryResult.new(e, has_more, idx)
}