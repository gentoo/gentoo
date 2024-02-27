# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs edo

DESCRIPTION="Utility to poison ARP caches"
HOMEPAGE="https://arpoison.sourceforge.net/ http://www.arpoison.net/"
SRC_URI="https://dev.gentoo.org/~jsmolic/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~riscv x86"

RDEPEND="net-libs/libnet:1.1"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_compile() {
	edo "$(tc-getCC)" "${PN}.c" -o "${PN}" ${CFLAGS} ${LDFLAGS} $("${BROOT}/usr/bin/libnet-config" --cflags --libs)
}

src_install() {
	dosbin arpoison
	doman arpoison.8
	dodoc README
}
