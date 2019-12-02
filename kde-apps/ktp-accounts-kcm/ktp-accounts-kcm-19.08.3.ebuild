# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE Telepathy account management kcm"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="experimental"

BDEPEND="
	dev-util/intltool
"
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-apps/kaccounts-integration-${PVCUT}:5
	net-libs/accounts-qt
	net-libs/signond
	net-libs/telepathy-qt[qt5(+)]
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	net-libs/libaccounts-glib
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kaccounts-providers-${PVCUT}:5
	net-im/telepathy-connection-managers
"

PATCHES=( "${FILESDIR}/${P}-telepathy-qt-0.9.8.patch" )

src_prepare() {
	if use experimental; then
		mv "${S}"/data/kaccounts/disabled/*.in "${S}"/data/kaccounts/ || \
			die "couldn't enable experimental services"
	fi
	ecm_src_prepare
}

pkg_postinst() {
	if use experimental; then
		ewarn "Experimental providers are enabled."
		ewarn "Most of them aren't integrated nicely and may require additional steps for account creation."
		ewarn "Use at your own risk!"
	fi
	ecm_pkg_postinst
}
