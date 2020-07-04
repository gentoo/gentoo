# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
inherit cmake kde.org

DESCRIPTION="Breeze SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"

BDEPEND="
	dev-qt/qtcore:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( dev-qt/qttest:5 )"

RESTRICT+=" !test? ( test )"

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DBINARY_ICONS_RESOURCE=OFF
	)
	cmake_src_configure
}
