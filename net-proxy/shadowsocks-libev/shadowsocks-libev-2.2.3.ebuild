# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A lightweight secured scoks5 proxy for embedded devices and low end boxes"
HOMEPAGE="https://github.com/shadowsocks/shadowsocks-libev"

MY_PV="v${PV}"
SRC_URI="https://github.com/shadowsocks/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +openssl polarssl"

DEPEND="openssl? ( dev-libs/openssl:= )
	polarssl? ( net-libs/polarssl )
	"
RDEPEND="${DEPEND}"

REQUIRED_USE=" ^^ ( openssl polarssl )"

src_configure() {
	econf \
		$(use_enable debug assert) \
		--with-crypto-library=$(usex openssl openssl polarssl)
}

src_install() {
	default
	prune_libtool_files --all

	insinto "/etc/"
	newins "${FILESDIR}/shadowsocks.json" shadowsocks.json

	newinitd "${FILESDIR}/shadowsocks.initd" shadowsocks
	dosym /etc/init.d/shadowsocks /etc/init.d/shadowsocks.server
	dosym /etc/init.d/shadowsocks /etc/init.d/shadowsocks.client
}

pkg_setup() {
	elog "You need to choose to run as server or client mode"
	elog "  server: rc-update add shadowsocks.server default"
	elog "  client: rc-update add shadowsocks.client default"
}
