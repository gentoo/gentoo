# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.9.0
inherit cmake frameworks.kde.org xdg-utils

DESCRIPTION="Oxygen SVG icon theme"
HOMEPAGE="https://develop.kde.org/frameworks/oxygen-icons/"

LICENSE="LGPL-3"
SLOT="6"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="!kde-frameworks/${PN}:5"
DEPEND="test? ( >=dev-qt/qtbase-${QTMIN}:6 )"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	>=kde-frameworks/extra-cmake-modules-${KDE_CATV}:0
	test? ( app-misc/fdupes )
"

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
