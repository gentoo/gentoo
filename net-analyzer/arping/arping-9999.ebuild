# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 fcaps

DESCRIPTION="A utility to see if a specific IP is taken and what MAC owns it"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
EGIT_REPO_URI="https://github.com/ThomasHabets/arping"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="2"
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
