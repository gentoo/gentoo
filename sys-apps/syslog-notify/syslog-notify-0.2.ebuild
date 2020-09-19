# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="Notifications for syslog entries via libnotify"
HOMEPAGE="https://jtniehof.github.com/syslog-notify/"
SRC_URI="https://github.com/downloads/jtniehof/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=x11-libs/libnotify-0.7"
RDEPEND="
	${DEPEND}
	|| (
		app-admin/syslog-ng
		app-admin/rsyslog
	)"

src_install() {
	default
	dodoc HACKING

	dodir /var/spool
	keepdir /var/spool

	local DISABLE_AUTOFORMATTING="yes"
	local DOC_CONTENTS="Add the following options on your /etc/syslog-ng/syslog-ng.conf
file:
#  destination notify { pipe("/var/spool/syslog-notify"); };
#  log { source(src); destination(notify);};

Remember to restart syslog-ng before starting syslog-notify."
	readme.gentoo_create_doc
}

pkg_postinst() {
	mkfifo "${EROOT}"/var/spool/syslog-notify
	readme.gentoo_print_elog
}
