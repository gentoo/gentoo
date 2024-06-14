# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Application to enable/disable qCDebug"
HOMEPAGE="https://apps.kde.org/kdebugsettings/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
