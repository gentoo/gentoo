# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit fcaps

DESCRIPTION="A utility to see if a specific IP address is taken and what MAC address owns it"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
SRC_URI="http://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1
"
DEPEND="
	${CDEPEND}
	test? ( dev-libs/check )
"
RDEPEND="
	${CDEPEND}
	!net-misc/iputils[arping(+)]
"

FILECAPS=( cap_net_raw /usr/sbin/arping )
