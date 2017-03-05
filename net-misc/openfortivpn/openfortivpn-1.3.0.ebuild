# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info

DESCRIPTION="A Fortinet compatible VPN client"
HOMEPAGE="https://github.com/adrienverge/openfortivpn"
SRC_URI="https://github.com/adrienverge/openfortivpn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3-with-openssl-exception openssl"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-dialup/ppp
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~PPP ~PPP_ASYNC"

src_prepare() {
	default

	sed -i 's/-Werror//g' Makefile.am || die "Failed to remove -Werror from Makefile.am"

	eautoreconf
}

src_install() {
	default

	keepdir /etc/openfortivpn
}
