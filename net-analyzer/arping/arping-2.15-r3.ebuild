# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils fcaps

DESCRIPTION="A utility to see if a specific IP address is taken and what MAC address owns it"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
SRC_URI="http://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

DEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1
"
RDEPEND="
	${DEPEND}
	!net-misc/iputils[arping(+)]
"

FILECAPS=( cap_net_raw /usr/sbin/arping )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.15-setgroups.patch

	eautoreconf
}
