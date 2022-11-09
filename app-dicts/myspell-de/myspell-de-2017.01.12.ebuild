# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"de_AT.aff"
	"de_AT.dic"
	"de_DE.aff"
	"de_DE.dic"
	"de_CH.aff"
	"de_CH.dic"
)

MYSPELL_HYPH=(
	"hyph_de_AT.dic"
	"hyph_de_DE.dic"
	"hyph_de_CH.dic"
)

MYSPELL_THES=(
	"th_de_AT_v2.dat"
	"th_de_AT_v2.idx"
	"th_de_DE_v2.dat"
	"th_de_DE_v2.idx"
	"th_de_CH_v2.dat"
	"th_de_CH_v2.idx"
)

inherit myspell-r2

MY_PV=$(ver_rs 1- -)	# YYYY-MM-DD

DESCRIPTION="German (AT,CH,DE) dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extensions/german-de-at-frami-dictionaries
	https://extensions.libreoffice.org/extensions/german-de-ch-frami-dictionaries
	https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries
"
SRC_URI="
	https://extensions.libreoffice.org/extensions/german-de-at-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_AT-frami_${MY_PV}.oxt
	https://extensions.libreoffice.org/extensions/german-de-ch-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_CH-frami_${MY_PV}.oxt
	https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries/${MY_PV}/@@download/file/dict-de_DE-frami_${MY_PV}.oxt
"

LICENSE="GPL-3 GPL-2 LGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	# fixing file names
	for i in *_frami.*; do
		mv "${i}" "${i/_frami}" || die
	done

	default
}
