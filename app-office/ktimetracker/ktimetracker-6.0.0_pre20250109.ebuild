# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=72017cd540ed4e7a5a443a493962f6e612cafde9
ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KDE_ORG_CATEGORY="pim"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Todo management and time tracker"
HOMEPAGE="https://userbase.kde.org/KTimeTracker"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
