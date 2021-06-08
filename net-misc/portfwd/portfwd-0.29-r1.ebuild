# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools systemd

DESCRIPTION="Port Forwarding Daemon"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://portfwd.sourceforge.net"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"

src_prepare() {
	default

	cd src
	sed -iorig \
		-e "s:^CFLAGS   =.*:CFLAGS   = @CFLAGS@ -Wall -DPORTFWD_CONF=\\\\\"\$(sysconfdir)/portfwd.cfg\\\\\":" \
		-e "s:^CXXFLAGS =.*:CPPFLAGS = @CXXFLAGS@ -Wall -DPORTFWD_CONF=\\\\\"\$(sysconfdir)/portfwd.cfg\\\\\":" \
		Makefile.am || die
	cd ../tools
	sed -iorig \
		-e "s:^CXXFLAGS =.*:CPPFLAGS = @CXXFLAGS@ -Wall -DPORTFWD_CONF=\\\\\"\$(sysconfdir)/portfwd.cfg\\\\\":" \
		Makefile.am || die
	cd ../getopt
	sed -iorig -e "s:$.CC.:\$(CC) @CFLAGS@:g" Makefile.am || die
	cd ../doc
	sed -iorig -e "s:/doc/portfwd:/share/doc/$P:" Makefile.am || die
	cd ..
	sed -iorig -e "s:/doc/portfwd:/share/doc/$P:" Makefile.am || die

	eautoreconf
}

src_install() {
	default

	dodoc cfg/*

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
