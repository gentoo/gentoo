service cvspserver
{
	disable		= yes
	socket_type	= stream
	wait		= no
	user		= root
	log_type	= FILE /var/log/cvspserver
	protocol	= tcp
	env		= HOME=/var/cvsroot
	log_on_failure	+= USERID
	port		= 2401
	server		= /usr/bin/cvs
	server_args	= -f --allow-root=/var/cvsroot pserver
}
