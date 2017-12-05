# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="cronolog wrapper for use with dumb daemons like squid, varnish and so on"
HOMEPAGE="https://cgit.gentoo.org/proj/fifo-cronolog.git"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/cronolog"

src_install() {
	dosbin fifo-cronolog

	newinitd fifo-cronolog.initd fifo-cronolog
	newconfd fifo-cronolog.confd fifo-cronolog

	dosym fifo-cronolog /usr/sbin/squid-cronolog
}

pkg_postinst() {
	elog "Warning: app-admin/squid-cronolog has been renamed to app-admin/fifo-cronolog."
	elog "This also applies to the binary 'squid-cronolog' but there is a symlink for now"
	elog "Please fix your scripts/configs."
}
