# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KDE_ORG_CATEGORY="pim"
PVCUT=$(ver_cut 1-3)
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Getting things done application by KDE"
HOMEPAGE="https://zanshin.kde.org/ https://apps.kde.org/zanshin/
https://userbase.kde.org/Zanshin"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # bug 785844

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-calendar-${PVCUT}:6
	>=kde-apps/akonadi-contacts-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/kontactinterface-${PVCUT}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/krunner-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kdepim-runtime-${PVCUT}:6
"
BDEPEND="
	test? ( >=kde-apps/akonadi-${PVCUT}:6[tools] )
"
