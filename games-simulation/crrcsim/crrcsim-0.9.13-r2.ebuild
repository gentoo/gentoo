# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Model-airplane flight simulation program"
HOMEPAGE="https://sourceforge.net/projects/crrcsim/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="portaudio"

RDEPEND="
	dev-libs/gmp:=
	media-libs/libsdl[X,sound,joystick,opengl,video]
	media-libs/plib
	virtual/glu
	virtual/jpeg
	virtual/opengl
	portaudio? ( media-libs/portaudio )"
DEPEND="
	${RDEPEND}
	sci-mathematics/cgal"

PATCHES=(
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-overlink.patch
	"${FILESDIR}"/${P}-clang.patch
)

DOCS=( AUTHORS HISTORY )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf ac_cv_header_portaudio_h=$(usex portaudio)
}

src_install() {
	default

	doicon packages/icons/${PN}.png
	make_desktop_entry ${PN} CRRCSim
}
