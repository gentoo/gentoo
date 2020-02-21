# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Advanced plugin and service introspection"
LICENSE="LGPL-2 LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="+man"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	man? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )
"
RDEPEND="
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kcrash-${PVCUT}:5
	>=kde-frameworks/kdbusaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
"

# requires running kde environment
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DAPPLICATIONS_MENU_NAME=kf5-applications.menu
		$(cmake_use_find_package man KF5DocTools)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# bug 596316
	dosym kf5-applications.menu /etc/xdg/menus/applications.menu
}
