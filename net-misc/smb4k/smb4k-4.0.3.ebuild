# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org xdg

DESCRIPTION="Advanced network neighborhood browser"
HOMEPAGE="https://apps.kde.org/smb4k/
https://sourceforge.net/p/smb4k/home/Home/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+discovery plasma"

DEPEND="
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	net-fs/samba[cups]
	discovery? (
		>=net-libs/kdsoap-2.2.0:=[qt6(+)]
		>=net-libs/kdsoap-ws-discovery-client-0.4.0
	)
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	plasma? (
		>=kde-frameworks/kirigami-${KFMIN}:6
		kde-plasma/libplasma:6
	)
"

src_configure() {
	local mycmakeargs=(
		-DSMB4K_WITH_WS_DISCOVERY=$(usex discovery)
		-DSMB4K_INSTALL_PLASMOID=$(usex plasma)
	)
	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Users of Samba 4.7 and above please note that for the time being,"
	elog "the following setting has to be added to or changed in the [global]"
	elog "section of the smb.conf file:"
	elog
	elog "[global]"
	elog "client max protocol = NT1"
}
