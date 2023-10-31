# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="Extract and concatenate portions of pcap files"
HOMEPAGE="http://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpslice"
SRC_URI="https://www.tcpdump.org/release/${P}.tar.gz
	verify-sig? ( https://www.tcpdump.org/release/${P}.tar.gz.sig )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-tcpdump )"
RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/tcpdump.asc"
