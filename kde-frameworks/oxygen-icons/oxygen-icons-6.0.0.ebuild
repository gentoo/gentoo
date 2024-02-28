# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0.0
QTMIN=6.6.2
inherit cmake kde.org xdg-utils

DESCRIPTION="Oxygen SVG icon theme"
HOMEPAGE="https://develop.kde.org/frameworks/oxygen-icons/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-3"
SLOT="6"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="!kde-frameworks/${PN}:5"
DEPEND="test? ( >=dev-qt/qtbase-${QTMIN}:6 )"
BDEPEND="
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:0
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
