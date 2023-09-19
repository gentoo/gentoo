# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="CLI interface to the X-10 Firecracker Kit"
HOMEPAGE="https://www.linuxha.com/bottlerocket/"
SRC_URI="https://www.linuxha.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

src_prepare() {
	default

	sed -e 's| -O2 ||' \
		-e '/ -o br /s|${CFLAGS}|& $(CPPFLAGS) $(LDFLAGS)|' \
		-i Makefile.in || die

	eautoreconf #874321
}

src_configure() {
	econf --with-x10port=/dev/firecracker
}

src_install() {
	dobin br
	dodoc README
}

pkg_postinst() {
	elog
	elog "Be sure to create a /dev/firecracker symlink to the"
	elog "serial port that has the Firecracker serial interface"
	elog "installed on it."
	elog
}
