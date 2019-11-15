# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="ARP scanning and fingerprinting tool"
HOMEPAGE="https://github.com/royhills/arp-scan"
EGIT_REPO_URI="https://github.com/royhills/arp-scan"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
	dev-lang/perl
"

src_prepare() {
	default
	eautoreconf
}
