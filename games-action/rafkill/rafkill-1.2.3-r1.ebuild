# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils scons-utils toolchain-funcs

DESCRIPTION="Space shoot-em-up game"
HOMEPAGE="http://raptorv2.sourceforge.net/"
SRC_URI="mirror://sourceforge/raptorv2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="<media-libs/allegro-5
	media-libs/aldumb"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	rm -f {data,music}/.sconsign || die

	sed -i \
		-e "/^#define INSTALL_DIR/s:\.:/usr/share:" \
		src/defs.cpp || die
}

src_compile() {
	tc-export CXX
	escons
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data music
	dodoc README
}
