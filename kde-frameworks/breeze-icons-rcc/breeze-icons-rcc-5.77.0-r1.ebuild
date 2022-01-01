# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="breeze-icons"
PVCUT=$(ver_cut 1-2)
inherit cmake kde.org

DESCRIPTION="Breeze SVG icon theme binary resource"
LICENSE="LGPL-3"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"

BDEPEND="
	dev-qt/qtcore:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( dev-qt/qttest:5 )"

RESTRICT+=" !test? ( test )"

PATCHES=( "${FILESDIR}/breeze-icons-${PV}-image-missing.patch" )

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DBINARY_ICONS_RESOURCE=ON
		-DSKIP_INSTALL_ICONS=ON
	)
	cmake_src_configure
}
