# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"latin-9/et_EE.aff"
	"latin-9/et_EE.dic"
)

MYSPELL_HYPH=(
	"hyph_et_EE.dic"
)

inherit myspell-r2

DESCRIPTION="Estonian dictionaries for myspell/hunspell"
HOMEPAGE="http://www.meso.ee/~jjpp/speller/"
SRC_URI="http://www.meso.ee/~jjpp/speller/ispell-et_${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

S="${WORKDIR}/ispell-et-${PV}"

src_prepare() {
	default
	# naming handling to be inline with others
	mv hyph_et.dic hyph_et_EE.dic || die
}
