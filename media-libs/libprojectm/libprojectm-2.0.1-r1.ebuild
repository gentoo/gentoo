# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils flag-o-matic eutils toolchain-funcs

MY_P=${P/m/M}-Source ; MY_P=${MY_P/lib}

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug openmp video_cards_nvidia"

RDEPEND=">=media-libs/ftgl-2.1.3_rc5
	media-libs/freetype:2
	media-libs/mesa
	media-libs/glew
	sys-libs/zlib
	video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-pcfix.patch
)

src_configure() {
	append-ldflags $(no-as-needed)

	if use video_cards_nvidia; then
		append-ldflags -L/opt/nvidia-cg-toolkit/lib
		append-flags -I/opt/nvidia-cg-toolkit/include
	fi

	local mycmakeargs=(
		$(cmake-utils_use_use video_cards_nvidia CG)
		"-DUSE_OPENMP=OFF"
	)

	if use openmp && tc-has-openmp; then
		mycmakeargs+=(
			$(cmake-utils_use_use openmp)
		)
	fi

	cmake-utils_src_configure
}
