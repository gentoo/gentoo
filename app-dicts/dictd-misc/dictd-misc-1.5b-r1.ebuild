# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/dictd-misc/dictd-misc-1.5b-r1.ebuild,v 1.13 2005/04/01 16:03:34 nigoro Exp $

MY_P=${P/dictd/dict}-pre
DESCRIPTION="Easton's 1897 Bible Dictionary for dict"
HOMEPAGE="http://www.dict.org/"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 ppc sparc amd64 ppc64"

DEPEND=">=app-text/dictd-1.5.5"

S=${WORKDIR}

src_install() {
	insinto /usr/lib/dict
	doins easton.dict.dz easton.index \
		hitchcock.dict.dz hitchcock.index \
		world95.dict.dz world95.index \
		|| die
}
