# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="cronolog wrapper for use with dumb daemons like squid, varnish and so on"
HOMEPAGE="https://gitweb.gentoo.org/proj/fifo-cronolog.git"
SRC_URI="http://dev.gentoo.org/~robbat2/distfiles/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/cronolog"

src_compile() {
	emake all
}

src_install() {
	dosbin fifo-cronolog
	dosym fifo-cronolog /usr/sbin/squid-cronolog
	dosbin fifo-cronolog-setup

	newinitd openrc/fifo-cronolog.initd fifo-cronolog
	newconfd openrc/fifo-cronolog.confd fifo-cronolog

	systemd_dounit systemd/fifo-cronolog@.service
	dodoc README.md systemd/fifo-cronolog@example.service.env
}

pkg_postinst() {
	elog "Warning: app-admin/squid-cronolog has been renamed to app-admin/fifo-cronolog."
	elog "This also applies to the binary 'squid-cronolog' but there is a symlink for now"
	elog "Please fix your scripts/configs."
}
