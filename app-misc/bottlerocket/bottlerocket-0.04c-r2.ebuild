# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="CLI interface to the X-10 Firecracker Kit"
HOMEPAGE="http://www.linuxha.com/bottlerocket/"
SRC_URI="http://www.linuxha.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~ppc ~sparc x86"

src_prepare() {
	default
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
	emake CC="$(tc-getCC)"
}

src_install() {
	dodoc README
	dobin br
}

pkg_postinst() {
	elog
	elog "Be sure to create a /dev/firecracker symlink to the"
	elog "serial port that has the Firecracker serial interface"
	elog "installed on it."
	elog
}
