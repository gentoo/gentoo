# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic toolchain-funcs

MY_P=${PN/m/M}-complete-${PV}-Source
MY_P=${MY_P/lib}

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ppc ppc64 sparc x86"
IUSE="debug openmp video_cards_nvidia"

RDEPEND="media-fonts/dejavu
	>=media-libs/ftgl-2.1.3_rc5
	media-libs/freetype:2
	media-libs/mesa[X(+)]
	media-libs/glew:=
	sys-libs/zlib
	video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}/src/libprojectM

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-path.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_configure() {
	if use video_cards_nvidia; then
		append-ldflags -L/opt/nvidia-cg-toolkit/$(get_libdir)
		append-ldflags -L/opt/nvidia-cg-toolkit/lib
		append-cppflags -I/opt/nvidia-cg-toolkit/include
	fi

	local mycmakeargs=(
		-DUSE_CG=$(usex video_cards_nvidia)
		-DprojectM_FONT_MENU="${EPREFIX}/usr/share/fonts/dejavu/DejaVuSans.ttf"
		-DprojectM_FONT_TITLE="${EPREFIX}/usr/share/fonts/dejavu/DejaVuSansMono.ttf"
	)

	if use openmp && tc-has-openmp; then
		mycmakeargs+=( -DUSE_OPENMP=ON )
	else
		mycmakeargs+=( -DUSE_OPENMP=OFF )
	fi

	cmake-utils_src_configure
}
