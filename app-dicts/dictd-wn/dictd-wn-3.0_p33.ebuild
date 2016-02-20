# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit unpacker

DESCRIPTION="WordNet for dict"
HOMEPAGE="http://wordnet.princeton.edu/"
SRC_URI="mirror://debian/pool/main/w/wordnet/dict-wn_${PV/_p/-}_all.deb"

LICENSE="Princeton"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=">=app-text/dictd-1.5.5"

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /usr/lib/dict
	doins usr/share/dictd/{wn.dict.dz,wn.index}
}
