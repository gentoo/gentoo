# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info

DESCRIPTION="Fortinet compatible VPN client"
HOMEPAGE="https://github.com/adrienverge/openfortivpn"
SRC_URI="https://github.com/adrienverge/openfortivpn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3-with-openssl-exception openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/openssl:=
	net-dialup/ppp
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~PPP ~PPP_ASYNC"

PATCHES=(
	"${FILESDIR}"/${PN}-1.02.3-systemd_substitute_bin_and_sysconfig_dirs.patch
	"${FILESDIR}"/${PN}-1.20.3-pppd-ipcp-accept-remote.patch
)

src_prepare() {
	default

	sed -i 's/-Werror//g' Makefile.am || die "Failed to remove -Werror from Makefile.am"

	eautoreconf
}

src_install() {
	default

	keepdir /etc/openfortivpn
}
