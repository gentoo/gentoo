# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Certificate manager and GUI for OpenPGP and CMS cryptography"
HOMEPAGE="https://apps.kde.org/kleopatra/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="pim"

# tests completely broken, bug #641720
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.16.0:=[cxx,qt5]
	dev-libs/libassuan:=
	dev-libs/libgpg-error
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	pim? (
		>=kde-apps/akonadi-mime-${PVCUT}:5
		>=kde-apps/kidentitymanagement-${PVCUT}:5
		>=kde-apps/kmailtransport-${PVCUT}:5
	)
"
RDEPEND="${DEPEND}
	>=app-crypt/gnupg-2.1
	app-crypt/paperkey
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pim KPim5AkonadiMime)
		$(cmake_use_find_package pim KPim5IdentityManagement)
		$(cmake_use_find_package pim KPim5MailTransport)
	)
	ecm_src_configure
}
