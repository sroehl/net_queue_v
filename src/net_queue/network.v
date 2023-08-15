module net_queue

import json
import net

pub fn start_server(port int, mut queues []Queue) {
	mut server := net.listen_tcp(.ip, ':${port}') or { return }
	laddr := server.addr() or { return }
	println('Listening on ${laddr}')
	for {
		mut socket := server.accept() or {println("Failed to start listening")
		return}
		spawn handle_client(mut socket, mut queues)
	}
}

fn handle_client(mut socket net.TcpConn, mut queues []Queue) {
	defer {
		//TODO: Improve error
		socket.close() or {panic(err)}
	}
	client_addr := socket.peer_addr() or { return }
	println('Client connected on ${client_addr}')
	for {
		line := socket.read_line()
		if line == '' {
			return
		} else {
			net_message := json.decode(NetMessage, line) or {
				println("failed to parse: ${err}")
				continue
			}
			if net_message.msg_type == int(MSGTypes.cmd) {
				resp := net_message.handle_cmd(mut queues)
				socket.write_string(json.encode(resp)) or {
					println("Error communicating to client")
					return
				}
			} else if net_message.msg_type == int(MSGTypes.write_entry) {
				resp := net_message.write_entry(mut queues)
				socket.write_string(json.encode(resp)) or {
					println("Error communicating to client")
					return
				}
			} else if net_message.msg_type == int(MSGTypes.read_entry) {
				resp := net_message.read_entry(mut queues)
					socket.write_string(json.encode(resp)) or {
					println("Error communicating to client")
					return
				}
			}
		}
	}
}
