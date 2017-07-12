# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cannadic eutils

DESCRIPTION="Japanese Canna dictionary for 2channelers"
HOMEPAGE="http://omaemona.sourceforge.net/packages/Canna"
SRC_URI="mirror://gentoo/${P}.tar.gz"
#SRC_URI="http://omaemona.sourceforge.net/packages/Canna/2ch.t"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ppc64 sparc x86"
IUSE="canna"

DEPEND="canna? ( app-i18n/canna )"
RDEPEND=""
S="${WORKDIR}/${PN}"

CANNADICS="2ch"
DICSDIRFILE="${FILESDIR}/052ch.dics.dir"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-canna36p4-gentoo.patch"
}

src_compile() {
	# Anthy users do not need binary dictionary
	if use canna ; then
		mkbindic nichan.ctd || die
	fi
}
