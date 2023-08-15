module net_queue

enum MSGTypes {
	cmd = 1
	write_entry = 2
	read_entry = 3
}

struct NetMessage {
	NetMessageCmd
	NetMessageEntry
	msg_type int [required]
}