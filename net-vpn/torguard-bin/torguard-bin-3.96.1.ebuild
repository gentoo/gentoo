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

	local f_torguard=./opt/torguard
	local f_icon=./usr/share/pixmaps/torguard.png
	local f_desktop=./usr/share/applications/torguard.desktop
	local f_policy=./usr/share/polkit-1/actions/com.torguard.policy
	local f_sudoer=./etc/sudoers.d/torguard

	local md_dest="/opt/torguard"
	dodir ${md_dest}

	insinto $md_dest
	doins -r "$f_torguard"/*

	doicon "$f_icon"
	insinto /usr/share/applications/
	doins "$f_desktop"
	insinto /usr/share/polkit-1/actions/
	doins "$f_policy"
	insinto /etc/sudoers.d/
	doins "$f_sudoer"

	fperms 755 "$md_dest"/bin/torguard
	fperms 755 "$md_dest"/bin/torguard-wrapper
	fperms 755 "$md_dest"/bin/ss-local
	fperms 755 "$md_dest"/bin/openvpn_v2_4
	fperms 755 "$md_dest"/bin/openconnect
	fperms 755 "$md_dest"/bin/vpnc-script
	fperms 755 "$md_dest"/bin/stunnel
	fperms 440 /etc/sudoers.d/torguard

	dosym "$md_dest"/bin/torguard-wrapper /usr/bin/torguard
}

pkg_setup() {
	enewuser torguard
	enewgroup torguard
}
