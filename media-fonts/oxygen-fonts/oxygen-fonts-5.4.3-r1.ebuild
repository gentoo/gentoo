# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake font kde.org xdg-utils

DESCRIPTION="Desktop/GUI font family for integrated use with the KDE Plasma desktop"
HOMEPAGE="https://invent.kde.org/unmaintained/oxygen-fonts"
SRC_URI="mirror://kde/unstable/plasma/$(ver_cut 1-3)/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="5"
KEYWORDS="amd64 ~arm x86"
IUSE=""

BDEPEND="
	>=dev-qt/qtcore-5.12.3:5
	>=kde-frameworks/extra-cmake-modules-5.60.0:5
	media-gfx/fontforge
"

DOCS=( README.md )

PATCHES=( "${FILESDIR}/${P}-fix-d-and-t-accents.patch" )

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
