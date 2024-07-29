# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop toolchain-funcs

DESCRIPTION="2d construction toy with objects that react on physical forces"
HOMEPAGE="http://www.nongnu.org/construo/"
SRC_URI="http://download-mirror.savannah.gnu.org/releases/construo/construo.pkg/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/freeglut
	virtual/glu
	virtual/opengl
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}/construo-0.2.3-clang.patch"
)

src_prepare() {
	default
	sed -i -e 's/^bindir=.*/bindir=@bindir@/' src/Makefile.am || die
	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	make_desktop_entry ${PN}.glut ${PN}.glut
	make_desktop_entry ${PN}.x11 ${PN}.x11
}
