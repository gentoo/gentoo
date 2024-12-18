# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KIO worker to discover file systems by DNS-SD (DNS Service Discovery)"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=net-misc/${PN}-common-${PV}
"

# Shipped by net-misc/kio-zeroconf-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/dbus-1/interfaces/org.kde.kdnssd.xml
	/usr/share/remoteview/zeroconf.desktop
	/usr/share/metainfo/org.kde.kio_zeroconf.metainfo.xml
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}
