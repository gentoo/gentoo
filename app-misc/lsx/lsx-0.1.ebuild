# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lsx/lsx-0.1.ebuild,v 1.8 2012/02/16 06:59:31 jer Exp $

inherit toolchain-funcs

DESCRIPTION="list executables"
HOMEPAGE="http://tools.suckless.org/lsx"
SRC_URI="http://suckless.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/.*strip.*//" \
		Makefile || die "sed failed"

	sed -i \
		-e "s/CFLAGS = -Os/CFLAGS +=/" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		config.mk || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	# collision with net-dialup/lrzsz
	mv "${D}/usr/bin/${PN}" "${D}/usr/bin/${PN}-suckless"

	dodoc README
}

pkg_postinst() {
	elog "Run ${PN} with ${PN}-suckless"
}
