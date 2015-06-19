# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xidle/xidle-24102005.ebuild,v 1.3 2012/03/14 05:03:17 jer Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="xidle monitors inactivity in X and runs the specified program when
a timeout occurs."
HOMEPAGE="http://www.freebsdsoftware.org/x11/xidle.html"
SRC_URI="mirror://freebsd/ports/local-distfiles/novel/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
	"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-dead.patch"
}

src_compile() {
	local my_compile="$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN}{,.c} -lXss -lX11"
	echo ${my_compile}
	eval ${my_compile} || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
