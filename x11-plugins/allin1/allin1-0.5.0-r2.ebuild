# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="All in one monitoring dockapp: RAM, CPU, Net, Power, df, seti"
HOMEPAGE="http://ilpettegolo.altervista.org/linux_allin1.en.shtml"
SRC_URI="mirror://sourceforge/allinone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/makefile-r2.patch" )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/allin1
	doman docs/allin1.1
	dodoc README README.it TODO ChangeLog BUGS src/allin1.conf.example
}
