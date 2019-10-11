# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"nl.aff"
	"nl.dic"
)

MYSPELL_HYPH=(
	"hyph_nl.dic"
)

MYSPELL_THES=(
	"th_nl_v2.dat"
	"th_nl_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Dutch dictionaries for myspell/hunspell"
HOMEPAGE="https://www.opentaal.org"
# Thesarus is not versioned at all, I suppose we could bump it with each dict
# release, or when people say that the download uri checksum changed.
SRC_URI="
	https://www.opentaal.org/bestanden/license_result/20-woordenlijst-v-${PV//./}-voor-openofficeorg-3?bid=20&agree=1 -> ${P}.oxt
	https://data.opentaal.org/opentaalbank/thesaurus/download/thes_nl.oxt -> ${P}_thes.oxt
"

LICENSE="BSD-2 CC-BY-3.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

src_prepare() {
	default
	# Fix regions, bug #607080
	mv nl_NL.aff nl.aff || die
	mv nl_NL.dic nl.dic || die
	mv hyph_nl_NL.dic hyph_nl.dic || die

	# remove dutch translated license so it aint installed
	rm -rf licentie* || die
}
