# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="breeze-icons"
inherit cmake-utils kde.org

DESCRIPTION="Breeze SVG icon theme binary resource"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

BDEPEND="
	kde-frameworks/extra-cmake-modules:5
	dev-qt/qtcore:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( dev-qt/qttest:5 )"

RESTRICT+=" !test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBINARY_ICONS_RESOURCE=ON
		-DSKIP_INSTALL_ICONS=ON
	)
	cmake-utils_src_configure
}
