# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.88.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Library for encryption handling"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="+fancyviewer"

RDEPEND="
	>=app-crypt/gpgme-1.16.0:=[cxx,qt5]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	fancyviewer? ( >=kde-apps/kpimtextedit-${PVCUT}:5 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

PATCHES=( "${FILESDIR}/${P}-gcc-12.patch" ) # bug 839921

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package fancyviewer KF5PimTextEdit)
	)

	ecm_src_configure
}
