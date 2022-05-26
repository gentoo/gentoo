# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MUTATIONS=(
	"es" "es_AR" "es_BO" "es_CL" "es_CO" "es_CR" "es_CU" "es_DO" "es_EC" "es_ES" "es_GT" "es_HN"
	"es_MX" "es_NI" "es_PA" "es_PE" "es_PH" "es_PR" "es_PY" "es_SV" "es_US" "es_UY" "es_VE"
)

MYSPELL_HYPH=(
	"hyph_es.dic"
)
MYSPELL_THES=(
	"th_es_v2.dat"
	"th_es_v2.idx"
)

for i in "${MUTATIONS[@]}"; do
	MYSPELL_DICT+=(
		"${i}.dic"
		"${i}.aff"
	)
	SRC_URI+=" https://github.com/sbosio/rla-es/releases/download/v${PV}/${i}.oxt -> ${i}-${PV}.oxt"
done

unset i MUTATIONS

inherit myspell-r2

DESCRIPTION="Spanish dictionaries for myspell/hunspell"
HOMEPAGE="https://github.com/sbosio/rla-es"
LICENSE="GPL-3+ LGPL-3+ MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	# remove license files
	rm {GPL,LGPL,MPL}* || die
	default
}
