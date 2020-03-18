# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="oxygen-icons5"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit cmake kde.org

DESCRIPTION="Oxygen SVG icon theme"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
IUSE="test"

BDEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( >=dev-qt/qttest-${QTMIN}:5 )"

RESTRICT+=" !test? ( test )"

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}
