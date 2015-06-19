# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pgpdump/pgpdump-0.29.ebuild,v 1.5 2015/02/27 11:05:06 ago Exp $

EAPI=5
inherit eutils

DESCRIPTION="A PGP packet visualizer"
HOMEPAGE="http://www.mew.org/~kazu/proj/pgpdump/"
SRC_URI="http://www.mew.org/~kazu/proj/pgpdump/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="sys-libs/zlib
	app-arch/bzip2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.28-respect-ldflags.patch
}

src_install() {
	dobin pgpdump
	doman pgpdump.1
	dodoc CHANGES README.md
}
