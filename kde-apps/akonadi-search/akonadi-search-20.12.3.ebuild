# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Libraries and daemons to implement searching in Akonadi"
HOMEPAGE="https://invent.kde.org/pim/akonadi-search"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

RESTRICT+=" test" # perpetually broken, bug 662378

BDEPEND="
	test? ( >=kde-apps/akonadi-${PVCUT}:5[tools] )
"
RDEPEND="
	>=dev-libs/xapian-1.3:=[chert(+)]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( >=kde-apps/akonadi-${PVCUT}:5[mysql,postgres,sqlite] )
"
