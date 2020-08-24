# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Getting things done application by KDE"
HOMEPAGE="https://zanshin.kde.org/ https://userbase.kde.org/Zanshin
https://kde.org/applications/utilities/org.kde.zanshin"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="5"
IUSE=""

BDEPEND="
	test? ( <kde-apps/akonadi-20.04.50[tools] )
"
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	<kde-apps/akonadi-20.04.50
	<kde-apps/akonadi-calendar-20.04.50
	<kde-apps/akonadi-contacts-20.04.50
	<kde-apps/kmime-20.04.50
	<kde-apps/kontactinterface-20.04.50
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!kde-misc/zanshin:4
	<kde-apps/kdepim-runtime-20.04.50
"
