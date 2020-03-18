# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Generates HTML IRC stats based on irssi logs"
HOMEPAGE="http://royale.zerezo.com/irssistats/"
SRC_URI="http://royale.zerezo.com/irssistats/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ppc sparc x86"

DEPEND="net-irc/irssi"

src_compile() {
	$(tc-getCC) -o irssistats ${CFLAGS} ${LDFLAGS} irssistats.c
}

src_install() {
	emake \
		PRE="${D}"/usr \
		DOC="${D}"/usr/share/doc/${PF} \
		install
}
