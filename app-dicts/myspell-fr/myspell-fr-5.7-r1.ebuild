# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"fr-classique.aff"
	"fr-classique.dic"
	"fr-moderne.aff"
	"fr-moderne.dic"
	"fr-reforme1990.aff"
	"fr-reforme1990.dic"
	"fr_FR.aff"
	"fr_FR.dic"
)

MYSPELL_HYPH=(
	"hyph_fr.dic"
	"hyph_fr.iso8859-1.dic"
)

MYSPELL_THES=(
	"thes_fr.dat"
	"thes_fr.idx"
)

inherit myspell-r2

DESCRIPTION="French dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/dictionnaires-francais"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/lo-oo-ressources-linguistiques-fr-v5-7.oxt"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~x86-linux"

DOCS=( package-description.txt README_dict_fr.txt README_hyph_fr-2.9.txt README_hyph_fr-3.0.txt README_thes_fr.txt )

src_prepare() {
	default
	mv fr-toutesvariantes.aff fr_FR.aff || die
	mv fr-toutesvariantes.dic fr_FR.dic || die
	rm -r french_flag_16.bmp french_flag.png || die
}
