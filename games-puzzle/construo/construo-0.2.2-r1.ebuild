# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="2d construction toy with objects that react on physical forces"
HOMEPAGE="http://www.nongnu.org/construo/"
SRC_URI="http://freesoftware.fsf.org/download/construo/construo.pkg/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	virtual/glu
	media-libs/freeglut
	x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-lGLU.patch
	sed -i -e 's/^bindir=.*/bindir=@bindir@/' Makefile.am || die
	eautoreconf
}

src_install() {
	default
	make_desktop_entry "${PN}.glut" "${PN}.glut"
	make_desktop_entry "${PN}.x11" "${PN}.x11"
}
