# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="network scanner that gathers info on SSH protocols and versions"
HOMEPAGE="http://monkey.org/~provos/scanssh/"
SRC_URI="http://monkey.org/~provos/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86"

DEPEND="
	dev-libs/libdnet
	dev-libs/libevent
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0-fix-warnings.diff
	touch configure
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin scanssh
	doman scanssh.1
}
