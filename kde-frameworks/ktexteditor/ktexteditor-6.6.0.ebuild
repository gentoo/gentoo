# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing a full text editor component"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+editorconfig"

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtspeech-${QTMIN}:6
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kauth-${PVCUT}*:6
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kcompletion-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kitemviews-${PVCUT}*:6
	=kde-frameworks/kjobwidgets-${PVCUT}*:6
	=kde-frameworks/kparts-${PVCUT}*:6
	=kde-frameworks/ktextwidgets-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6
	=kde-frameworks/kxmlgui-${PVCUT}*:6
	=kde-frameworks/sonnet-${PVCUT}*:6
	=kde-frameworks/syntax-highlighting-${PVCUT}*:6
	editorconfig? ( app-text/editorconfig-core-c )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( >=kde-frameworks/kservice-${PVCUT}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package editorconfig EditorConfig)
	)

	ecm_src_configure
}
