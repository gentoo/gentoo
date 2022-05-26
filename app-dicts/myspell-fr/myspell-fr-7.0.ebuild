# Copyright 1999-2022 Gentoo Authors
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
HOMEPAGE="https://grammalecte.net/"
SRC_URI="https://github.com/scardracs/gentoo-packages/releases/download/fr-20201207/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~x86-linux"

DOCS=( package-description.txt README_dict_fr.txt README_hyph_fr-2.9.txt README_hyph_fr-3.0.txt README_thes_fr.txt )
