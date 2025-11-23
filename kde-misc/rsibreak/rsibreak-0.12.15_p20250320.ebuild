# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.8.0
QTMIN=6.7.2
KDE_ORG_COMMIT=3adfd5510b2eed1cdf005b7bcf60690b87d6932e
inherit ecm kde.org

DESCRIPTION="Small utility which bothers you at certain intervals"
HOMEPAGE="https://apps.kde.org/rsibreak/ https://userbase.kde.org/RSIBreak"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
# bug 587170 for frameworkintegration
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	>=kde-frameworks/frameworkintegration-${KFMIN}:6
"
BDEPEND="sys-devel/gettext"
