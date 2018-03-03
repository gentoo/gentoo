# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit fcaps user

DESCRIPTION="Bridge for UDP tunnels, Ethernet, TAP and VMnet interfaces."
HOMEPAGE="https://github.com/GNS3/ubridge"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="net-libs/libpcap:="

RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ubridge
}

src_prepare() {
	default

	sed -i -e "s/CFLAGS  =/CFLAGS  ?=/g" Makefile || die "Failed to fix Makefile"
}

src_install() {
	insinto /usr/bin
	insopts -m 750 -g ubridge
	doins ubridge
	dodoc README.rst
}

pkg_postinst() {
	fcaps -g ubridge -m 4710 -M 0710 cap_net_raw,cap_net_admin \
		"${EROOT%/}"/usr/bin/ubridge

	ewarn "NOTE: To read packets from the network interfaces with ubridge as"
	ewarn "normal user you have to add the appropriate user to the ubridge group."
}
