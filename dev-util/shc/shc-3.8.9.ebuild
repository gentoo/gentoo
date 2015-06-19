# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shc/shc-3.8.9.ebuild,v 1.4 2012/10/15 05:05:21 armin76 Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="A (shell-) script compiler/scrambler"
HOMEPAGE="http://www.datsi.fi.upm.es/~frosal"
SRC_URI="http://www.datsi.fi.upm.es/~frosal/sources/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE=""

RESTRICT="test"

src_prepare() {
	# respect LDFLAGS
	sed -i makefile -e 's:$(CC) $(CFLAGS):& $(LDFLAGS):' || die
	# fix source file name wrt bug #433970
	mv {${P},${PN}}.c || die
}

src_compile() {
	## the "test"-target leads to an access-violation -> so we skip it
	## as it's only for demonstration purposes anyway.
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" shc
}

src_install() {
	dobin shc
	doman shc.1
	newdoc shc.README README
	dodoc CHANGES
}
