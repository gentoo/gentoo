# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/picp/picp-0.6.8.ebuild,v 1.4 2014/08/10 20:03:55 slyfox Exp $

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="A commandline interface to Microchip's PICSTART+ programmer"
HOMEPAGE="http://home.pacbell.net/theposts/picmicro/"
SRC_URI="http://home.pacbell.net/theposts/picmicro/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

src_prepare() {
	sed -i -e '/strip/d' \
		-e 's:$(CC):\0 $(LDFLAGS):' \
		{.,fixchksum,picsnoop}/Makefile || die "sed failed"

	rm -f picsnoop/{picsnoop,*.o}

	epatch "${FILESDIR}"/${P}-errno.patch
}

src_compile() {
	emake CC=$(tc-getCC) OPTIONS="${CFLAGS} -x c++"
	emake -C picsnoop CC=$(tc-getCC) OPTIONS="${CFLAGS} -x c++"
	emake -C fixchksum CC=$(tc-getCC) OPTIONS="${CFLAGS}"
}

src_install() {
	dobin picp
	dobin picsnoop/picsnoop
	dobin fixchksum/fixchksum
	dodoc README HISTORY LICENSE.TXT NOTES PSCOMMANDS.TXT BugReports.txt TODO
	newdoc picsnoop/README.TXT PICSNOOP.txt
	newdoc fixchksum/README fixchksum.txt
	dohtml PICPmanual.html
}
