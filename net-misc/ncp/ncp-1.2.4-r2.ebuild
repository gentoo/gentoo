# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility for copying files in a LAN (npoll, npush)"
HOMEPAGE="https://www.fefe.de/ncp/"
SRC_URI="https://dl.fefe.de/${P}.tar.bz2"

LICENSE="public-domain" # mail from author, bug 446540
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/libowfat-0.28-r1[-diet]"

PATCHES=( "${FILESDIR}/${P}-fix-makefile.patch" )

src_prepare() {
	default
	rm Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -I/usr/include/libowfat" \
		LDFLAGS="${LDFLAGS}" \
		STRIP="#"
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/npoll
	dosym ${PN} /usr/bin/npush

	doman ncp.1 npush.1
	dodoc NEWS
}
