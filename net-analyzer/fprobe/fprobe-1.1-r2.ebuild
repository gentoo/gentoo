# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fprobe/fprobe-1.1-r2.ebuild,v 1.2 2014/07/11 12:55:05 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="A libpcap-based tool to collect network traffic data and emit it as NetFlow flows"
HOMEPAGE="http://fprobe.sourceforge.net"
LICENSE="GPL-2"

SRC_URI="mirror://sourceforge/fprobe/${P}.tar.bz2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="debug messages"

DEPEND="net-libs/libpcap"

src_prepare() {
	# The pidfile should be created by the parent process, before the
	# setuid/chroot is executed.
	epatch "${FILESDIR}"/fprobe-1.1-pidfile-sanity.patch
	# This seems to fail, uncertain why.
	epatch "${FILESDIR}"/fprobe-1.1-setgroups.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable messages)
}

DOCS=( AUTHORS NEWS README TODO )

src_install() {
	default

	docinto contrib
	dodoc contrib/tg.sh

	newinitd "${FILESDIR}"/init.d-fprobe fprobe
	newconfd "${FILESDIR}"/conf.d-fprobe fprobe
}
