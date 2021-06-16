# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="WordNet for dict"
HOMEPAGE="https://wordnet.princeton.edu"
SRC_URI="mirror://debian/pool/main/w/wordnet/dict-wn_${PV/_p/-}_all.deb"
S="${WORKDIR}"
LICENSE="Princeton"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND=">=app-text/dictd-1.5.5"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /usr/share/dict
	doins usr/share/dictd/{wn.dict.dz,wn.index}
}
