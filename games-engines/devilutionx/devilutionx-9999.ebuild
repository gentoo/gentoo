# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Sometimes build with ninja fails.
# Please check occasionally if we can revert back to ninja.
# Latest known issue:
#   https://github.com/diasurgical/devilutionX/issues/490
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake desktop

DESCRIPTION="Diablo engine for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diasurgical/devilutionX.git"
else
	SRC_URI="https://github.com/diasurgical/devilutionX/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/devilutionX-${PV}"
fi

LICENSE="public-domain"
SLOT="0"

IUSE="debug lto"

RDEPEND="
	dev-libs/libsodium
	media-fonts/sil-charis
	media-libs/libsdl2[haptic]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	sed "/PROJECT_VERSION/s|@PROJECT_VERSION@|${PV}|" \
		-i SourceS/config.h.in || die
	sed 's/CharisSILB.ttf/CharisSIL-B.ttf/g' \
		-i SourceX/DiabloUI/fonts.h || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DASAN="OFF"
		-DDEBUG="$(usex debug)"
		-DDIST="ON"
		-DFASTER="OFF"
		-DLTO="$(usex lto)"
		-DUBSAN="OFF"
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/${PN}"

	newicon -s 32 Packaging/resources/Diablo_32.png ${PN}.png
	newicon -s 48 Packaging/resources/Diablo_48.png ${PN}.png
	make_desktop_entry ${PN} "Diablo devolved" "/usr/share/icons/hicolor/48x48/apps/devilutionx.png"
}

pkg_postinst() {
	einfo "In order to play the game you need to install the file"
	einfo "  diabdat.mpq"
	einfo "from the original game CD into the following directory:"
	einfo "  \${HOME}/.local/share/diasurgical/devilution/"
	einfo "and make sure it's writeable (chmod u+w)."
}
