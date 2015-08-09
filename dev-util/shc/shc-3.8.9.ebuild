# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
