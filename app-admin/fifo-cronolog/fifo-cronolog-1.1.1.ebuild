# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

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
	dosbin fifo-cronolog || die

	newinitd fifo-cronolog.initd fifo-cronolog || die
	newconfd fifo-cronolog.confd fifo-cronolog || die

	dosym /usr/sbin/fifo-cronolog /usr/sbin/squid-cronolog || die
}

pkg_postinst() {
	elog "Warning: app-admin/squid-cronolog has been renamed to app-admin/fifo-cronolog."
	elog "This also applies to the binary 'squid-cronolog' but there is a symlink for now"
	elog "Please fix your scripts/configs."
}
