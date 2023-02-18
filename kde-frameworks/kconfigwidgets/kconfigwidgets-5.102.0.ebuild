# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing an assortment of configuration-related widgets"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+man"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kauth-${PVCUT}*:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF5DocTools)
	)

	ecm_src_configure
}
