# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing different actions given a string query"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kitemmodels-${KDE_CATV}*:6
	=kde-frameworks/kwindowsystem-${KDE_CATV}*:6[wayland]
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# requires virtual dbus, otherwise hangs; bugs #630672
	dbusrunnertest
	# bug 789351
	runnermanagersinglerunnermodetest
	# bug 838502
	runnermanagertest
	# bug 926502, needs dbus
	threadingtest
)
