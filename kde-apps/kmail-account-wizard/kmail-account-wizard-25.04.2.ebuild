# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Assistant for KMail accounts configuration"
HOMEPAGE+=" https://userbase.kde.org/KMail/Account_Wizard"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # bug 926456; requires akonadi server

DEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx,qt6]
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
