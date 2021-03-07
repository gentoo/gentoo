# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Sometimes build with ninja fails.
# Please check occasionally if we can revert back to ninja.
# Latest known issue:
#
#CMAKE_MAKEFILE_GENERATOR="emake"

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

IUSE="debug +hellfire lto"

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

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-no_bundled_font.patch" #704508
)

src_configure() {
	local mycmakeargs=(
		-DASAN="OFF"
		-DDEBUG="$(usex debug)"
		-DDISABLE_LTO="$(usex !lto)"
		-DDIST="ON"
		-DUBSAN="OFF"
		-DHELLFIRE="$(usex hellfire)"
	)
	cmake_src_configure

	if [[ "${PV}" != 9999 ]] ; then
		# Build system still doesn't reliably set release version
		sed "/PROJECT_VERSION/s@-@${PV}@" -i "${BUILD_DIR}/config.h" \
			|| die
	fi
}

pkg_postinst() {
	einfo "In order to play the game you need to install the file"
	einfo "  diabdat.mpq"
	einfo "from the original game CD into the following directory:"
	einfo "  \${HOME}/.local/share/diasurgical/devilution/"
}
