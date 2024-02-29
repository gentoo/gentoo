# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Libraries and daemons to implement searching in Akonadi"
HOMEPAGE="https://invent.kde.org/pim/akonadi-search"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test" # perpetually broken, bug 662378

RDEPEND="
	>=dev-libs/ktextaddons-1.5.2:6
	>=dev-libs/xapian-1.3:=[chert(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-mime-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/krunner-${KFMIN}:6
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( >=kde-apps/akonadi-${PVCUT}:6[mysql,postgres,sqlite] )
"
BDEPEND="
	test? ( >=kde-apps/akonadi-${PVCUT}:6[tools] )
"
