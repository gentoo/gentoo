# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing an assortment of configuration-related widgets"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

CMAKE_SKIP_TESTS=(
	# bugs: 864250
	kstandardactiontest
	# bug 926497
	klanguagenametest
)

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kcodecs-${KDE_CATV}*:6
	=kde-frameworks/kcolorscheme-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kguiaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
"
DEPEND="${RDEPEND}
	test? ( =kde-frameworks/kconfig-${KDE_CATV}*:6[dbus] )
"
