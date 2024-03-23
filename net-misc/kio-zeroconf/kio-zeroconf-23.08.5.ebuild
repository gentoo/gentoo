# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KIO worker to discover file systems by DNS-SD (DNS Service Discovery)"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="kf6compat"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}
	kf6compat? ( net-misc/kio-zeroconf:6 )
"

src_install() {
	ecm_src_install

	if use kf6compat; then
		rm "${D}"/usr/share/metainfo/org.kde.kio_zeroconf.metainfo.xml \
			"${D}"/usr/share/dbus-1/interfaces/org.kde.kdnssd.xml \
			"${D}"/usr/share/remoteview/zeroconf.desktop || die
		rm -r "${D}"/usr/share/locale || die
	fi
}
