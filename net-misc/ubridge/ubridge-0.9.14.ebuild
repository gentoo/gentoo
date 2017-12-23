# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fcaps toolchain-funcs user

DESCRIPTION="Bridge for UDP tunnels, Ethernet, TAP and VMnet interfaces"
HOMEPAGE="https://github.com/GNS3/ubridge"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-libs/libpcap
	dev-libs/iniparser:=
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}"/${P}-respect-flags.patch )

pkg_setup() {
	enewgroup ubridge
}

src_configure() {
	export SYSTEM_INIPARSER=1
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	exeinto /usr/bin
	exeopts -m 710 -g ubridge
	doexe ubridge
	dodoc README.rst
}

pkg_postinst() {
	fcaps -g ubridge -m 4710 -M 0710 cap_net_raw,cap_net_admin \
		"${EROOT}"/usr/bin/ubridge

	ewarn "NOTE: To read packets from the network interfaces with ubridge as"
	ewarn "normal user you have to add trusted users to the ubridge group."
}
