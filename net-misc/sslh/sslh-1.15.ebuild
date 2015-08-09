# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Port multiplexer - accept both HTTPS and SSH connections on the same port"
HOMEPAGE="http://www.rutschle.net/tech/sslh.shtml"
SRC_URI="http://www.rutschle.net/tech/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tcpd"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
	dev-libs/libconfig"
DEPEND="${RDEPEND}
	dev-lang/perl"

RESTRICT="test"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		USELIBWRAP=$(usev tcpd)
}

src_install() {
	dosbin sslh-{fork,select}
	dosym sslh-fork /usr/sbin/sslh
	doman sslh.8.gz
	dodoc ChangeLog README

	newinitd "${FILESDIR}"/sslh.init.d-2 sslh
	newconfd "${FILESDIR}"/sslh.conf.d-2 sslh
}
