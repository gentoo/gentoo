# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/scanssh/scanssh-2.1.ebuild,v 1.13 2014/07/16 22:58:19 jer Exp $

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
