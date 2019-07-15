# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual Router Redundancy Protocol Daemon"
HOMEPAGE="http://www.sourceforge.net/projects/vrrpd"
SRC_URI="mirror://sourceforge/${PN}/${PN}/1.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-devel/gcc"
RDEPEND=""

src_compile() {
	emake DBG_OPT="" MACHINEOPT="${CFLAGS}" PROF_OPT="${LDFLAGS}"
}

src_install() {
	dosbin vrrpd
	doman vrrpd.8
	dodoc FAQ Changes TODO scott_example doc/draft-ietf-vrrp-spec-v2-05.txt doc/rfc2338.txt.vrrp doc/draft-jou-duplicate-ip-address-02.txt
}
