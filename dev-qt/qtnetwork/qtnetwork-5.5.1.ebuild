# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Network abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 hppa ppc64 ~x86"
fi

IUSE="bindist connman libproxy networkmanager +ssl"

DEPEND="
	~dev-qt/qtcore-${PV}
	>=sys-libs/zlib-1.2.5
	connman? ( ~dev-qt/qtdbus-${PV} )
	libproxy? ( net-libs/libproxy )
	networkmanager? ( ~dev-qt/qtdbus-${PV} )
	ssl? ( dev-libs/openssl:0[bindist=] )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.5-socklen_t.patch" # bug 554556
)

QT5_TARGET_SUBDIRS=(
	src/network
	src/plugins/bearer/generic
)

QT5_GENTOO_CONFIG=(
	libproxy
	ssl::SSL
	ssl::OPENSSL
	ssl:openssl-linked:LINKED_OPENSSL
)

pkg_setup() {
	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

src_configure() {
	local myconf=(
		$(use connman || use networkmanager && echo -dbus-linked)
		$(qt_use libproxy)
		$(use ssl && echo -openssl-linked)
	)
	qt5-build_src_configure
}
