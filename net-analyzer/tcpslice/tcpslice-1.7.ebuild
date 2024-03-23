# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/tcpdump.asc"
inherit verify-sig

DESCRIPTION="Extract and concatenate portions of pcap files"
HOMEPAGE="http://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpslice"
SRC_URI="
	https://www.tcpdump.org/release/${P}.tar.xz
	verify-sig? ( https://www.tcpdump.org/release/${P}.tar.xz.sig )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-tcpdump-20240308 )"
