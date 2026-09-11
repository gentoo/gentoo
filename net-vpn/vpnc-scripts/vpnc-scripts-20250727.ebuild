# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/openconnect/vpnc-scripts.git"
else
	COMMIT="ce9e961bd0f6b867e1c7c35f78f6fb973f6ff101"
	SRC_URI="https://gitlab.com/openconnect/vpnc-scripts/-/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Connect scripts for use with vpnc and openconnect (and similar clients)"
HOMEPAGE="https://gitlab.com/openconnect/vpnc-scripts"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="!<net-vpn/vpnc-0.5.3_p550-r3"

src_install() {
	exeinto /etc/vpnc
	doexe vpnc-script{,-{ptrtd,sshd}}
}
