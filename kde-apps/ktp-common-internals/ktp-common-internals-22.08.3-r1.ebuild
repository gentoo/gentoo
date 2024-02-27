# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="KDE Telepathy common library"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="otr +sso"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=net-libs/telepathy-logger-qt-17.08.0:5
	>=net-libs/telepathy-qt-0.9.8
	otr? (
		dev-libs/libgcrypt:0=
		>=net-libs/libotr-4.0.0
	)
	sso? (
		>=kde-apps/kaccounts-integration-${PVCUT}:5
		net-libs/accounts-qt[qt5(+)]
		net-libs/telepathy-accounts-signon
	)
"
DEPEND="${RDEPEND}
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package sso KAccounts)
		$(cmake_use_find_package sso AccountsQt5)
		$(cmake_use_find_package otr Libgcrypt)
		$(cmake_use_find_package otr LibOTR)
	)

	ecm_src_configure
}
