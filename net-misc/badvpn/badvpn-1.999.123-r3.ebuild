# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils cmake-utils user

MY_P=${PN}-${PV/_rc/rc}
DESCRIPTION="Peer-to-peer VPN, NCD scripting language, tun2socks proxifier"
HOMEPAGE="https://code.google.com/p/badvpn/"
SRC_URI="https://badvpn.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="BSD"
KEYWORDS="amd64 x86"
SLOT="0"
TARGETS="+client +ncd +server +tun2socks +udpgw"
IUSE="${TARGETS} debug"

COMMON_DEPEND="
	client? (
		dev-libs/nspr
		dev-libs/nss
		dev-libs/openssl
	)
	server? (
		dev-libs/nspr
		dev-libs/nss
		dev-libs/openssl
	)
	ncd? (
		dev-libs/openssl
	)"
RDEPEND="${COMMON_DEPEND}
	ncd? (
		net-firewall/iptables
		net-wireless/wpa_supplicant
		sys-apps/iproute2
		>=virtual/udev-171
	)"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
# we need at least one target
REQUIRED_USE="|| ( ${TARGETS//+/} )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser ${PN}
}

src_prepare() {
	# allow user to easily apply patches
	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_NOTHING_BY_DEFAULT=1
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_build ncd NCD)
		$(cmake-utils_use_build tun2socks TUN2SOCKS)
		$(cmake-utils_use_build udpgw UDPGW)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog

	if use server; then
		newinitd "${FILESDIR}"/${PN}-server.init ${PN}-server
		newconfd "${FILESDIR}"/${PN}-server.conf ${PN}-server
	fi

	if use ncd; then
		newinitd "${FILESDIR}"/${PN}-ncd.init ${PN}-ncd
		newconfd "${FILESDIR}"/${PN}-ncd.conf ${PN}-ncd
	fi
}
