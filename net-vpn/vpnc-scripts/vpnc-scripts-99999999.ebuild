# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/openconnect/vpnc-scripts.git"
else
	SRC_URI="ftp://ftp.infradead.org/pub/vpnc-scripts/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Connect scripts for use with vpnc and openconnect (and similar clients)"
HOMEPAGE="https://gitlab.com/openconnect/vpnc-scripts"

LICENSE="GPL-2+"
SLOT="0"

src_install() {
	exeinto /etc/vpnc-scripts
	doexe vpnc-script{,-{ptrtd,sshd}}
}
