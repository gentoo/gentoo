# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

DESCRIPTION="Advanced network neighborhood browser"
HOMEPAGE="https://apps.kde.org/smb4k/
https://sourceforge.net/p/smb4k/home/Home/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz
		https://dev.gentoo.org/~asturm/distfiles/${PN}-3.2.5-bundled-kdsoap-ws-discovery-client.patch.xz"
	KEYWORDS="amd64 ~arm64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="+discovery plasma"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	net-fs/samba[cups]
	discovery? ( net-libs/kdsoap:=[qt5(+)] )
"
RDEPEND="${DEPEND}
	plasma? (
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
		>=kde-plasma/libplasma-${KFMIN}:5
	)
"

PATCHES=(
	"${WORKDIR}/${PN}-3.2.5-bundled-kdsoap-ws-discovery-client.patch"
)

src_configure() {
	local mycmakeargs=(
		-DSMB4K_WITH_WS_DISCOVERY=$(usex discovery)
		-DSMB4K_INSTALL_PLASMOID=$(usex plasma)
	)

	use discovery && mycmakeargs+=(
		# do not attempt to find now Qt6-based system version
		-DCMAKE_DISABLE_FIND_PACKAGE_KDSoapWSDiscoveryClient=ON
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "Users of Samba 4.7 and above please note that for the time being,"
	elog "the following setting has to be added to or changed in the [global]"
	elog "section of the smb.conf file:"
	elog
	elog "[global]"
	elog "client max protocol = NT1"
}
