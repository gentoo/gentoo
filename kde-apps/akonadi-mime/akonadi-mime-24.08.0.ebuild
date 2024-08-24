# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Library for akonadi mime types"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/libxslt"
