# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=${P/td/t}
DESCRIPTION="WordNet for dict"
HOMEPAGE="http://www.dict.org/"
SRC_URI="ftp://ftp.dict.org/pub/dict/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=app-text/dictd-1.5.5"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "configure failed"
	emake || die "compile failed"
	emake db || die "compile database failed"
}

src_install() {
	insinto /usr/lib/dict
	doins wn.dict.dz wn.index || die
}
