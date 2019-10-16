# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5 font

DESCRIPTION="Desktop/GUI font family for integrated use with the KDE Plasma desktop"
HOMEPAGE="https://cgit.kde.org/oxygen-fonts.git"
SRC_URI="mirror://kde/unstable/plasma/$(ver_cut 1-3)/${P}.tar.xz"

LICENSE="OFL-1.1"
KEYWORDS="amd64 ~arm x86"
IUSE=""

BDEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
	media-gfx/fontforge
"

DOCS=( README.md )

PATCHES=( "${FILESDIR}/${P}-fix-d-and-t-accents.patch" )

src_configure() {
	local mycmakeargs=(
		-DOXYGEN_FONT_INSTALL_DIR="${FONTDIR}"
	)
	kde5_src_configure
}

src_install() {
	kde5_src_install
	font_src_install
}
