# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=6b83344d65f4e039b947d15261c11ae80ed3900d
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.9.0
QTMIN=6.8.1
VIRTUALX_REQUIRED="test"
inherit ecm kde.org xdg

DESCRIPTION="Stopwatch application"
HOMEPAGE="https://apps.kde.org/kronometer https://userbase.kde.org/Kronometer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
