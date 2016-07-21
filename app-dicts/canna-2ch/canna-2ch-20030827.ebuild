# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit cannadic eutils

DESCRIPTION="Japanese Canna dictionary for 2channelers"
HOMEPAGE="http://omaemona.sourceforge.net/packages/Canna/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
#SRC_URI="http://omaemona.sourceforge.net/packages/Canna/2ch.t"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ppc64 sparc x86"
IUSE="canna"

DEPEND="canna? ( app-i18n/canna )"
RDEPEND=""
# You cannot use 2ch.cbd as its name. Canna doesn't load dictionaries
# if the name begins with number. (I don't know why ...)
CANNADICS="2ch"

S=${WORKDIR}/${PN}

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
