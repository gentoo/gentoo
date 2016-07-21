# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_P=${P/_/}
MY_P=${MY_P/-/_}
DESCRIPTION="powerful tool for testing stability of hardware and software utilizing IP protocols"
HOMEPAGE="http://www.mirrors.wiretapped.net/security/packet-construction/rain/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
SRC_URI="
	mirror://ubuntu/pool/universe/r/${PN}/${MY_P}.orig.tar.gz
	mirror://ubuntu/pool/universe/r/${PN}/${MY_P}-1.diff.gz
"

S="${WORKDIR}/${MY_P/_/-}"

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-1.diff
	epatch "${FILESDIR}"/${P}-gentoo.patch

	eautoreconf
}

DOCS=( BUGS CHANGES README TODO )
