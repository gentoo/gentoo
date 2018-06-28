# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

DESCRIPTION="A tinydns logging helper app"
HOMEPAGE="http://www.morettoni.net/tinystats.en.html"
SRC_URI="http://www.morettoni.net/bsd/${P}.tar.gz"
IUSE="ipv6"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86"
RDEPEND="net-dns/djbdns"
S=${WORKDIR}/${PN}

src_compile() {
	use ipv6 && IPV6="-D WITH_IPV6"
	$(tc-getCC) ${CFLAGS} ${IPV6} -o tinystats ${LDFLAGS} tinystats.c || \
		die "compile failed"
}

src_install() {
	dobin tinystats || die 'dobin failed'
	dodoc README
	docinto sample
	dodoc start_slave.sh.sample update_slave.sh.sample \
		tinydns.log.run.sample tinydns.sh.sample
}
