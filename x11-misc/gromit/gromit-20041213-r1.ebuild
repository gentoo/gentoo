# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gromit/gromit-20041213-r1.ebuild,v 1.6 2012/05/05 04:53:40 jdhore Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="GRaphics Over MIscellaneous Things, a presentation helper"
HOMEPAGE="http://www.home.unix-ag.org/simon/gromit"
SRC_URI="http://www.home.unix-ag.org/simon/gromit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i Makefile \
		-e 's:-Wall:-Wall $(CFLAGS) $(LDFLAGS):' \
		-e 's:gcc:$(CC):g' \
		|| die "sed Makefile failed"

	# Drop DEPRECATED flags, bug #387833
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED ::g' \
		Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dobin ${PN}
	newdoc ${PN}rc ${PN}rc.example
	dodoc AUTHORS ChangeLog README
}
