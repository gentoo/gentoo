# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm kde.org xdg

DESCRIPTION="Stopwatch application"
HOMEPAGE="https://apps.kde.org/kronometer https://userbase.kde.org/Kronometer"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${P}.tar.xz" # at 2f328db4

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
