# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base cmake-utils flag-o-matic eutils toolchain-funcs multilib

MY_P=${PN/m/M}-complete-${PV}-Source ; MY_P=${MY_P/lib}

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug openmp video_cards_nvidia"

RDEPEND="media-fonts/dejavu
	>=media-libs/ftgl-2.1.3_rc5
	media-libs/freetype:2
	media-libs/mesa
	media-libs/glew
	sys-libs/zlib
	video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}/src/libprojectM

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-path.patch
)

src_configure() {
	if use video_cards_nvidia; then
		append-ldflags -L/opt/nvidia-cg-toolkit/$(get_libdir)
		append-ldflags -L/opt/nvidia-cg-toolkit/lib
		append-cppflags -I/opt/nvidia-cg-toolkit/include
	fi

	local mycmakeargs=(
		$(cmake-utils_use_use video_cards_nvidia CG)
		"-DUSE_OPENMP=OFF"
		"-DprojectM_FONT_MENU=${EPREFIX}/usr/share/fonts/dejavu/DejaVuSans.ttf"
		"-DprojectM_FONT_TITLE=${EPREFIX}/usr/share/fonts/dejavu/DejaVuSansMono.ttf"
	)

	if use openmp && tc-has-openmp; then
		mycmakeargs+=(
			$(cmake-utils_use_use openmp)
		)
	fi

	cmake-utils_src_configure
}
