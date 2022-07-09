# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A Window Maker applet that shows your biorhythm"
HOMEPAGE="http://wmbio.sourceforge.net/"
SRC_URI="mirror://sourceforge/wmbio/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )
S=${WORKDIR}/${P}/src

src_prepare() {
	default
	# Honour Gentoo CFLAGS, LDFLAGS, CC
	sed -i -e "s/-g -O2/\$(CFLAGS)/" \
		-e "s/-o wmbio/\$(LDFLAGS) -o wmbio/" \
		-e "s/cc /\$(CC) /" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin wmbio
	dodoc ../{AUTHORS,Changelog,NEWS,README}
}
