# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps toolchain-funcs

DESCRIPTION="Bridge for UDP tunnels, Ethernet, TAP and VMnet interfaces"
HOMEPAGE="https://github.com/GNS3/ubridge"
SRC_URI="https://github.com/GNS3/ubridge/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3+"

RDEPEND="
	acct-group/ubridge
	dev-libs/iniparser:4=
	net-libs/libpcap"

DEPEND="${RDEPEND}"

# Bugs: https://bugs.gentoo.org/647588
#       https://github.com/GNS3/ubridge/issues/60
PATCHES=( "${FILESDIR}/${PN}-0.9.16_add_slotted_iniparser-4.1+_support.patch" )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		SYSTEM_INIPARSER=1
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

	einfo "\nNOTE: To read packets from the network interfaces with ubridge as"
	einfo "normal user you have to add trusted users to the \"ubridge\" group.\n"
}
