# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user desktop

DESCRIPTION="TorGuard VPN Client"
HOMEPAGE="https://torguard.net"
MY_P="torguard-v${PV}-amd64-arch"
SRC_URI="https://updates.torguard.biz/Software/Linux/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-apps/iproute2"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	unpack "${MY_P}/${MY_P}".tar
	rm "${MY_P}/${MY_P}".tar || die
}

src_install() {

	local opt_root="/opt/torguard"
	dodir ${opt_root}

	insinto $opt_root
	doins -r "./opt/torguard"/*

	doicon "./usr/share/pixmaps/torguard.png"
	domenu "./usr/share/applications/torguard.desktop"
	insinto /usr/share/polkit-1/actions
	doins "./usr/share/polkit-1/actions/com.torguard.policy"
	insinto /etc/sudoers.d
	doins "./etc/sudoers.d/torguard"

	fperms 755 "$opt_root"/bin/torguard
	fperms 755 "$opt_root"/bin/torguard-wrapper
	fperms 755 "$opt_root"/bin/ss-local
	fperms 755 "$opt_root"/bin/openvpn_v2_4
	fperms 755 "$opt_root"/bin/openconnect
	fperms 755 "$opt_root"/bin/vpnc-script
	fperms 755 "$opt_root"/bin/stunnel
	fperms 440 /etc/sudoers.d/torguard

	dosym "$opt_root"/bin/torguard-wrapper /usr/bin/torguard
}

pkg_setup() {
	enewuser torguard
	enewgroup torguard
}
