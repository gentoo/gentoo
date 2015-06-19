# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bottlerocket/bottlerocket-0.04c-r1.ebuild,v 1.3 2011/11/28 11:48:02 phajdan.jr Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="CLI interface to the X-10 Firecracker Kit"
HOMEPAGE="http://www.linuxha.com/bottlerocket/"
SRC_URI="http://www.linuxha.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

src_prepare() {
	# inset LDFLAGS
	sed -i Makefile.in \
		-e 's| -O2 ||g' \
		-e '/ -o br /s|${CFLAGS}|& $(LDFLAGS)|g' \
		|| die "sed Makefile.in"
}

src_configure() {
	econf --with-x10port=/dev/firecracker
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	einstall || die "einstall"
	dodoc README
}

pkg_postinst() {
	elog
	elog "Be sure to create a /dev/firecracker symlink to the"
	elog "serial port that has the Firecracker serial interface"
	elog "installed on it."
	elog
}
