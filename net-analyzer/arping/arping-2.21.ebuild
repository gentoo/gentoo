# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fcaps

DESCRIPTION="A utility to see if a specific IP is taken and what MAC owns it"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1"
DEPEND="
	${CDEPEND}
	test? (
		dev-libs/check
		dev-python/subunit )"
RDEPEND="
	${CDEPEND}
	!net-misc/iputils[arping(+)]"

FILECAPS=( cap_net_raw /usr/sbin/arping )

S=${WORKDIR}/${PN}-${P}

# patch is in upstream master
PATCHES=( "${FILESDIR}/arping-tests.patch" )

src_prepare() {
	default
	eautoreconf
}
