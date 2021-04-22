# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"ca_ES.aff"
	"ca_ES.dic"
	"ca_ES-valencia.aff"
	"ca_ES-valencia.dic"
)

MYSPELL_HYPH=(
	"hyph_ca_ES.dic"
)

MYSPELL_THES=(
	"th_ca_ES_v3.idx"
	"th_ca_ES_v3.dat"
)

inherit myspell-r2

DESCRIPTION="Catalan dictionaries for myspell/hunspell"
HOMEPAGE="https://www.softcatala.org/programes/corrector-ortografic-de-catala-general-per-al-libreoffice-i-lapache-openoffice/ https://github.com/Softcatala/catalan-dict-tools/"
SRC_URI="https://github.com/Softcatala/catalan-dict-tools/releases/download/v${PV}/ca.${PV}.oxt"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

src_prepare() {
	default

	# rename to conform the common naming scheme
	mv ca.aff ca_ES.aff || die
	mv ca.dic ca_ES.dic || die
	mv ca-ES-valencia.aff ca_ES-valencia.aff || die
	mv ca-ES-valencia.dic ca_ES-valencia.dic || die
	mv hyph_ca.dic hyph_ca_ES.dic || die

	# remove licenses
	rm LICENSES-en.txt LLICENCIES-ca.txt || die
}
