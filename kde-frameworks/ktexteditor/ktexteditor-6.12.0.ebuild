# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
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
	=kde-frameworks/karchive-${KDE_CATV}*:6
	=kde-frameworks/kauth-${KDE_CATV}*:6
	=kde-frameworks/kcodecs-${KDE_CATV}*:6
	=kde-frameworks/kcompletion-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kconfigwidgets-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kguiaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kiconthemes-${KDE_CATV}*:6
	=kde-frameworks/kio-${KDE_CATV}*:6
	=kde-frameworks/kitemviews-${KDE_CATV}*:6
	=kde-frameworks/kjobwidgets-${KDE_CATV}*:6
	=kde-frameworks/kparts-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/kwindowsystem-${KDE_CATV}*:6
	=kde-frameworks/kxmlgui-${KDE_CATV}*:6
	=kde-frameworks/sonnet-${KDE_CATV}*:6
	=kde-frameworks/syntax-highlighting-${KDE_CATV}*:6
	editorconfig? ( app-text/editorconfig-core-c )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( >=kde-frameworks/kservice-${KDE_CATV}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package editorconfig EditorConfig)
	)

	ecm_src_configure
}
