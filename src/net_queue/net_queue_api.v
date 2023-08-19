module net_queue

import net
import json
import io
import time

struct Server {
	host string
	port int
	mut:
		connected bool
		conn net.TcpConn
}

fn Server.new(host string, port int) Server {
	return Server {host: host
				   port: port}
}


pub fn (mut s Server) create_queue(queue_name string) !NetReponse {
	net_cmd := NetMessageCmd{command: "create_queue"
							arguments: queue_name
							}
	return s.send_cmd(net_cmd) or {}
}

pub fn (mut s Server) delete_queue(queue_name string) !NetReponse {
	net_cmd := NetMessageCmd{command: "delete_queue"
							arguments: queue_name
							}
	return s.send_cmd(net_cmd)!
}

pub fn (mut s Server) purge_queue(queue_name string) !NetReponse {
	net_cmd := NetMessageCmd{command: "purge_queue",
							arguments: queue_name}
	return s.send_cmd(net_cmd)!
}

pub fn (mut s Server) list_queues() !NetReponse {
	net_cmd := NetMessageCmd{command: "list_queues"
							}
	return s.send_cmd(net_cmd)!
}

// TODO: Read messages

// TODO: Write messages

fn (mut s Server) exit() ?NetReponse{
	net_cmd := NetMessageCmd{command: "exit"}
	return s.send_cmd(net_cmd) or {}
}

fn (mut s Server) send_cmd(net_cmd NetMessageCmd) !NetReponse{
	s.connect()
	net_msg := NetMessage{msg_type: int(MSGTypes.cmd)
						 NetMessageCmd: net_cmd}
	s.conn.set_read_timeout(2 * time.second)
	s.conn.write_string("${json.encode(net_msg)}\n") or {
		return NetReponse.new(Status.fail, "Failure in writing to server")
	}
	result := io.read_all(reader: s.conn) or {
		return NetReponse.new(Status.fail, "Failure in reading from server")
	}
	return json.decode(NetReponse, result.bytestr())
}

fn (mut s Server) connect() {
	if !s.connected {
		s.conn = net.dial_tcp("${s.host}:${s.port}")  or {panic(err)}
		s.conn.set_read_timeout(2 * time.second)
	}
}

fn (mut s Server) disconnect() {
	if s.connected {
		s.conn.close() or {}
	}
}