# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5 font xdg-utils

DESCRIPTION="Desktop/GUI font family for integrated use with the KDE Plasma desktop"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/oxygen-fonts"
SRC_URI="mirror://kde/unstable/plasma/$(ver_cut 1-3)/${P}.tar.xz"

LICENSE="OFL-1.1"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
	media-gfx/fontforge
"

DOCS=( README.md )

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DOXYGEN_FONT_INSTALL_DIR="${FONTDIR}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	font_src_install
}
