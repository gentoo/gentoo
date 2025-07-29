# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_PYTHON_BINDINGS="off"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for managing menu and toolbar actions in an abstract way"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE=""

# slot op: includes QtCore/private/qlocale_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,network,ssl,widgets,xml]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kconfigwidgets-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kglobalaccel-${KDE_CATV}*:6
	=kde-frameworks/kguiaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kiconthemes-${KDE_CATV}*:6
	=kde-frameworks/kitemviews-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# bug 668198: files are missing; whatever.
	ktoolbar_unittest
	# bug 650290
	kxmlgui_unittest
	# bug 808216
	ktooltiphelper_unittest
)
