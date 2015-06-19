# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-nl/myspell-nl-2.10g.ebuild,v 1.3 2013/02/07 21:23:34 ulm Exp $

EAPI=4

MYSPELL_DICT=(
	"nl_NL.aff"
	"nl_NL.dic"
)

MYSPELL_HYPH=(
	"hyph_nl_NL.dic"
)

MYSPELL_THES=(
	"th_nl_NL_v2.dat"
	"th_nl_NL_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Dutch dictionaries for myspell/hunspell"
HOMEPAGE="http://opentaal.org/"
# Thesarus is not versioned at all, I suppose we could bump it with each dict
# release, or when people say that the download uri checksum changed.
SRC_URI="
	http://opentaal.org/bestanden/license_result/20-woordenlijst-v-${PV//./}-voor-openofficeorg-3?bid=20&agree=1 -> ${P}.oxt
	http://data.opentaal.org/opentaalbank/thesaurus/download/thes_nl.oxt -> ${P}_thes.oxt
"

LICENSE="BSD-2 CC-BY-3.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_prepare() {
	# thesarus has ugly name
	mv th_nl_v2.dat th_nl_NL_v2.dat || die
	mv th_nl_v2.idx th_nl_NL_v2.idx || die

	# remove dutch translated license so it aint installed
	rm -rf licentie* || die
}
