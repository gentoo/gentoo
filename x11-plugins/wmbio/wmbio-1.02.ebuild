# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	x11-proto/xextproto"

S=${WORKDIR}/${P}/src

src_prepare() {
	default

	# Honour Gentoo CFLAGS
	sed -i "s/-g -O2/\$(CFLAGS)/" Makefile || die "sed CFLAGS failed"

	# Honour Gentoo LDFLAGS
	sed -i "s/-o wmbio/\$(LDFLAGS) -o wmbio/" Makefile || die "sed LDFLAGS failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install () {
	dobin wmbio || die "dobin failed"
}
