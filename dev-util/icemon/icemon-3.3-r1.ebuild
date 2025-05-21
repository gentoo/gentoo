# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Monitor program for use with Icecream compile clusters based on KDE Frameworks"
HOMEPAGE="https://en.opensuse.org/Icecream https://github.com/icecc/icemon"
SRC_URI="https://github.com/icecc/icemon/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sys-devel/icecream-1.3
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook2X
	kde-frameworks/extra-cmake-modules
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-cmake-4.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
	)

	cmake_src_configure
}
