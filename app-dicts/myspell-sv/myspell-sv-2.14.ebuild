# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MYSPELL_DICT=(
	"sv_FI.aff"
	"sv_FI.dic"
	"sv_SE.aff"
	"sv_SE.dic"
)

MYSPELL_HYPH=(
	"hyph_sv_SE.dic"
)

MYSPELL_THES=(
	"th_sv_SE.dat"
	"th_sv_SE.idx"
)

inherit myspell-r2

DESCRIPTION="Swedish dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extension-center/swedish-spelling-dictionary-den-stora-svenska-ordlistan
	https://extensions.libreoffice.org/extension-center/swedish-hyphenation
	https://extensions.libreoffice.org/extension-center/swedish-thesaurus-based-on-synlex
"
SRC_URI="
	https://extensions.libreoffice.org/extension-center/swedish-spelling-dictionary-den-stora-svenska-ordlistan/releases/${PV}/ooo_swedish_dict_${PV}.oxt
	https://extensions.libreoffice.org/extension-center/swedish-hyphenation/releases/1.10/hyph_sv_se.oxt -> ${P}-hyph.oxt
	https://extensions.libreoffice.org/extension-center/swedish-thesaurus-based-on-synlex/releases/1.3/swedishthesaurus.oxt -> ${P}-thes.oxt
"

LICENSE="CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""
