module net_queue

enum Status {
	success
	error
	fail
	has_more
	unknown
}

struct NetReponse {
	status Status = .unknown
	msg string
	mut:
		index int = -1
}

fn NetReponse.new(status Status, msg string) NetReponse {
	return NetReponse {status: status
					   msg: msg}
}