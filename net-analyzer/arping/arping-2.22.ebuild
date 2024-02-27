# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fcaps

DESCRIPTION="Utility to see if a specific IP is taken and what MAC owns it"
HOMEPAGE="https://www.habets.pp.se/synscan/programs.php?prog=arping"
SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1
	!net-misc/iputils[arping(+)]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/check
		dev-python/subunit
	)
"

FILECAPS=( cap_net_raw usr/sbin/arping )

src_prepare() {
	default
	eautoreconf
}
