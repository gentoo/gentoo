# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Notebook battery indicator for X"
HOMEPAGE="http://www.clave.gr.jp/~eto/xbatt/"
SRC_URI="http://www.clave.gr.jp/~eto/xbatt/${P}.tar.gz"

LICENSE="xbatt"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libxkbfile
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake"

src_prepare(){
	epatch "${FILESDIR}"/${P}-implicits.patch
}

src_compile() {
	xmkmf || die
	emake xbatt CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README* || die
}
