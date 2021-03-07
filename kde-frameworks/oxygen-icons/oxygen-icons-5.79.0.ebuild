# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="oxygen-icons5"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
inherit cmake kde.org xdg-utils

DESCRIPTION="Oxygen SVG icon theme"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

RESTRICT+=" !test? ( test )"

BDEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( >=dev-qt/qttest-${QTMIN}:5 )"

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
