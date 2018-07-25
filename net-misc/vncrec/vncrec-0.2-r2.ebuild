# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="VNC session recorder and player"
HOMEPAGE="http://www.sodan.org/~penny/vncrec/"
SRC_URI="http://www.sodan.org/~penny/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
"
DEPEND="${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/gccmakedep
	x11-misc/imake
"

DOCS=( README README.vnc )

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-includes.patch
	touch vncrec/vncrec.man || die
	sed -i Imakefile -e '/make Makefiles/d'	|| die
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CXXFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		World
}
