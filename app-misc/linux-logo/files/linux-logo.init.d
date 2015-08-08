#!/sbin/runscript

ISSUE_BACKUP_FILE="/etc/issue.linux-logo.backup"
ISSUE_NET_BACKUP_FILE="/etc/issue.net.linux-logo.backup"

start() {
	ebegin "Starting linux_logo"

	if [ ! -x /usr/bin/linux_logo ]
	then
		eerror "ERROR:  linux_logo not found !"
		return 1
	fi

	ebegin "  Creating /etc/issue"
	cp /etc/issue ${ISSUE_BACKUP_FILE} 2> /dev/null
	/usr/bin/linux_logo ${LOGO} ${OPTIONS} -F "${FORMAT}" > /etc/issue
	eend $? "  Failed to create /etc/issue"

	if [ -f /etc/issue.net ]
	then
		ebegin "  Creating /etc/issue.net"
		cp /etc/issue.net ${ISSUE_NET_BACKUP_FILE} 2> /dev/null
		/usr/bin/linux_logo ${LOGO} ${OPTIONS} -F "${FORMATNET}" > \
			/etc/issue.net
		eend $? "  Failed to create /etc/issue.net"
	fi
}

stop() {
	ebegin "Stopping linux_logo"
	[ -f ${ISSUE_NET_BACKUP_FILE} ] && \
		mv ${ISSUE_NET_BACKUP_FILE} /etc/issue.net 2> /dev/null
	[ -f ${ISSUE_BACKUP_FILE} ] && \
		mv ${ISSUE_BACKUP_FILE} /etc/issue 2> /dev/null
}
