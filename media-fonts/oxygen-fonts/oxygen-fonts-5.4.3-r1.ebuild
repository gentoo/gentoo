# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake font kde.org xdg-utils

DESCRIPTION="Desktop/GUI font family for integrated use with the KDE Plasma desktop"
HOMEPAGE="https://invent.kde.org/unmaintained/oxygen-fonts"
SRC_URI="mirror://kde/Attic/plasma/${PV}/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="5"
KEYWORDS="amd64 ~arm ~loong x86"
IUSE=""

BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	media-gfx/fontforge
"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-d-and-t-accents.patch"
	"${FILESDIR}/${P}-cmake4.patch" # bug 957482
)

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DOXYGEN_FONT_INSTALL_DIR="${FONTDIR}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	font_src_install
}
