# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Maps ethernet frame ids to symbolic names"
HOMEPAGE="https://netfilter.org/"
# File extracted from the iptables tarball
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

RDEPEND="
	!<net-firewall/ebtables-2.0.10.4-r2
	!<net-firewall/iptables-1.6.2-r2[nftables(-)]
"

S=${WORKDIR}

src_install() {
	insinto /etc
	newins "${P}" ethertypes
}
