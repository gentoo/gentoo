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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86"

src_prepare() {
	default

	# rename terroritory specific to just language, bug #607080
	mv nl_NL.aff nl.aff || die
	mv nl_NL.dic nl.dic || die
	mv hyph_nl_NL.dic hyph_nl.dic || die

	# remove dutch translated license so it aint installed
	rm licentie* || die
}

src_install() {
	myspell-r2_src_install

	# make language_territory locale format symlinks to base language files, bug #699660
	dosym ../hunspell/nl.aff /usr/share/myspell/nl_NL.aff
	dosym ../hunspell/nl.dic /usr/share/myspell/nl_NL.dic
	dosym ../hyphen/hyph_nl.dic /usr/share/myspell/hyph_nl_NL.dic
	dosym ../mythes/th_nl_v2.dat /usr/share/myspell/th_nl_NL_v2.dat
	dosym ../mythes/th_nl_v2.idx /usr/share/myspell/th_nl_NL_v2.idx

	# Belgium
	dosym ../hunspell/nl.aff /usr/share/myspell/nl_BE.aff
	dosym ../hunspell/nl.dic /usr/share/myspell/nl_BE.dic
	dosym ../hyphen/hyph_nl.dic /usr/share/myspell/hyph_nl_BE.dic
	dosym ../mythes/th_nl_v2.dat /usr/share/myspell/th_nl_BE_v2.dat
	dosym ../mythes/th_nl_v2.idx /usr/share/myspell/th_nl_BE_v2.idx
}
