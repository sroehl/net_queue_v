module net_queue

enum Status {
	success
	error
	has_more
}

struct NetReponse {
	status Status
	msg string
	mut:
		index int = -1
}

fn NetReponse.new(status Status, msg string) NetReponse {
	return NetReponse {status: status
					   msg: msg}
}