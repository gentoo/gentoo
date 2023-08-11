# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Recreation of HoMM2 game engine"
HOMEPAGE="https://ihhub.github.io/fheroes2/"
SRC_URI="https://github.com/ihhub/fheroes2/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="tools"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	media-libs/libpng:=
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	app-arch/libarchive
	dev-lang/python
	virtual/libintl
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/fheroes2-1.0.4-scripts.patch"
)

src_configure() {
	# Not using dev-games/libsmacker because the game crashes with it
	local mycmakeargs=(
		-DENABLE_IMAGE=ON
		-DENABLE_TOOLS=$(usex tools)
		-DUSE_SYSTEM_LIBSMACKER=NO
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	emake -C files/lang
}

src_install() {
	cmake_src_install

	if use tools; then
		for file in 82m2wav bin2txt extractor h2dmgr icn2img pal2img til2img xmi2midi; do
			newbin "${BUILD_DIR}/${file}" "fheroes2-${file}"
		done
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "You need original HoMM2 data files to play fheroes2."
	elog "If you have an installer (.exe) from GOG, install:"
	elog "  games-strategy/homm2-gold-gog"
	elog "If you have the original game installed somewhere already, run:"
	elog "  ${EPREFIX}/usr/share/fheroes2/extract_homm2_resources.sh"
	elog "Also you can automatically get a demo version for free by installing:"
	elog "  games-strategy/homm2-demo"
}
