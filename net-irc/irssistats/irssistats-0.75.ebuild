# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssistats/irssistats-0.75.ebuild,v 1.7 2014/08/10 20:53:20 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="Generates HTML IRC stats based on irssi logs"
HOMEPAGE="http://royale.zerezo.com/irssistats/"
SRC_URI="http://royale.zerezo.com/irssistats/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_compile() {
	$(tc-getCC) -o irssistats ${CFLAGS} ${LDFLAGS} irssistats.c || die "compile failed"
}

src_install() {
	emake \
		PRE="${D}"/usr \
		DOC="${D}"/usr/share/doc/${PF} \
		install \
		|| die "make install failed"
}
