# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps flag-o-matic toolchain-funcs

DESCRIPTION="Bridge for UDP tunnels, Ethernet, TAP and VMnet interfaces"
HOMEPAGE="https://github.com/GNS3/ubridge"
SRC_URI="https://github.com/GNS3/ubridge/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/ubridge
	>=dev-libs/iniparser-4.1-r2:=
	net-libs/libpcap"

DEPEND="${RDEPEND}"

src_compile() {
	# iniparser.pc only exists in >=4.2 and it changes headers location
	has_version '>=dev-libs/iniparser-4.2' &&
		append-cflags $($(tc-getPKG_CONFIG) --cflags iniparser || die)

	emake \
		CC="$(tc-getCC)" \
		SYSTEM_INIPARSER=1
}

src_install() {
	exeinto /usr/bin
	exeopts -m 710 -g ubridge
	doexe ubridge

	dodoc README.md
}

pkg_postinst() {
	fcaps -g ubridge -m 4710 -M 0710 cap_net_raw,cap_net_admin \
		"${EROOT}"/usr/bin/ubridge

	einfo "\nNOTE: To read packets from the network interfaces with ubridge as"
	einfo "normal user you have to add trusted users to the \"ubridge\" group.\n"
}
