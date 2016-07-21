# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Randomize lines from text files or stdin"
HOMEPAGE="http://ch.tudelft.nl/~arthur/rl/"
SRC_URI="http://ch.tudelft.nl/~arthur/rl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~mips ppc s390 sparc x86"
IUSE="debug"

src_compile() {
	local myconf=""

	use debug && myconf="${myconf} --enable-debug"

	econf ${myconf}
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO || die
}
