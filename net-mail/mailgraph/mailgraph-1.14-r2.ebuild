# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A mail statistics RRDtool frontend for Postfix"
HOMEPAGE="http://mailgraph.schweikert.ch/"
SRC_URI="http://mailgraph.schweikert.ch//pub/${P}.tar.gz"

LICENSE="GPL-2"
# Change SLOT to 0 when appropriate
SLOT="1.14"
KEYWORDS="amd64 x86"

# for the RRDs
DEPEND="
	acct-group/mgraph
	acct-user/mgraph"
RDEPEND="
	${DEPEND}
	dev-lang/perl
	dev-perl/File-Tail
	>=net-analyzer/rrdtool-1.2.2[graph,perl]"

PATCHES=( "${FILESDIR}"/${PN}-1.14-homedir.patch )

src_install() {
	# log and pid file
	diropts ""
	dodir /var/log
	dodir /var/run
	diropts -omgraph -gadm -m0750
	dodir /var/log/mailgraph
	keepdir /var/log/mailgraph

	# logrotate config for mailgraph log
	diropts ""
	dodir /etc/logrotate.d
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mailgraph.logrotate-new mailgraph

	# mailgraph daemon
	newbin mailgraph.pl mailgraph

	# mailgraph CGI script
	exeinto /usr/share/mailgraph
	doexe mailgraph.cgi
	insinto /usr/share/mailgraph
	doins mailgraph.css

	# init/conf files for mailgraph daemon
	newinitd "${FILESDIR}"/mailgraph.initd-new mailgraph
	newconfd "${FILESDIR}"/mailgraph.confd-new mailgraph

	# docs
	dodoc README CHANGES
}

pkg_postinst() {
	elog "Mailgraph will run as user mgraph with group adm by default."
	elog "This can be changed in /etc/conf.d/mailgraph if it doesn't fit."
	elog "Remember to adjust MG_DAEMON_LOG, MG_DAEMON_PID and MG_DAEMON_RRD"
	elog "as well!"

	ewarn "Please make sure the MG_LOGFILE (default: /var/log/messages) is readable"
	ewarn "by group adm or change MG_DAEMON_GID in /etc/conf.d/mailgraph accordingly!"
	ewarn
	ewarn "Please make sure *all* mail related logs (MTA, spamfilter, virus scanner)"
	ewarn "go to the file /var/log/messages or change MG_LOGFILE in"
	ewarn "/etc/conf.d/mailgraph accordingly! Otherwise mailgraph won't get to know"
	ewarn "the corresponding events (virus/spam mail found etc.)."

	elog
	elog "Checking for user apache:"
	if egetent passwd apache >&/dev/null; then
		elog "Adding user apache to group mgraph so the included"
		elog "CGI script is able to read the mailgraph RRD files"
		if ! gpasswd -a apache mgraph >&/dev/null; then
			eerror "Failed to add user apache to group mgraph!"
			eerror "Please check manually."
		fi
	else
		elog
		elog "User apache not found, maybe we will be running a"
		elog "webserver with a different UID?"
		elog "If that's the case, please add that user to the"
		elog "group mgraph manually to enable the included"
		elog "CGI script to read the mailgraph RRD files:"
		elog
		elog "\tgpasswd -a <user> mgraph"
	fi

	ewarn
	ewarn "mailgraph.cgi is installed in /usr/share/${PN}/"
	ewarn "You need to put it somewhere accessible though a web-server."
}
