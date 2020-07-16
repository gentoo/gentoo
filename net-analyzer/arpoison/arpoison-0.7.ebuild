# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A utility to poison ARP caches"
HOMEPAGE="http://arpoison.sourceforge.net/ http://www.arpoison.net/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	net-libs/libnet:1.1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
"

src_compile() {
	local compile="$(tc-getCC) ${PN}.c -o ${PN} ${CFLAGS} ${LDFLAGS} $("${BROOT}/usr/bin/libnet-config" --cflags --libs)"
	echo "${compile}"
	${compile} || die
}

src_install() {
	dosbin arpoison
	doman arpoison.8
	dodoc README
}
