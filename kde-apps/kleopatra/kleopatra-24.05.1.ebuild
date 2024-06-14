# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Certificate manager and GUI for OpenPGP and CMS cryptography"
HOMEPAGE="https://apps.kde.org/kleopatra/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="~amd64"
IUSE="pim"

# tests completely broken, bug #641720
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx,qt6]
	dev-libs/libassuan
	dev-libs/libgpg-error
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/libkleo-${PVCUT}:6
	>=kde-apps/mimetreeparser-${PVCUT}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	pim? (
		>=kde-apps/akonadi-mime-${PVCUT}:6
		>=kde-apps/kidentitymanagement-${PVCUT}:6
		>=kde-apps/kmailtransport-${PVCUT}:6
	)
"
RDEPEND="${DEPEND}
	>=app-crypt/gnupg-2.1
	app-crypt/paperkey
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pim KPim6AkonadiMime)
		$(cmake_use_find_package pim KPim6IdentityManagement)
		$(cmake_use_find_package pim KPim6MailTransport)
	)
	ecm_src_configure
}
