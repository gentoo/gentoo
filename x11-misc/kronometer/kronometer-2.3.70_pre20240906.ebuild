# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=e87e16c8e623a8f5646f5286ac02ac9298dbb235
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.5.0
QTMIN=6.7.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

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
