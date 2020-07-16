# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"it_IT.aff"
	"it_IT.dic"
)

MYSPELL_HYPH=(
	"hyph_it_IT.dic"
)

MYSPELL_THES=(
	"th_it_IT.dat"
	"th_it_IT.idx"
)

inherit myspell-r2

DESCRIPTION="Italian dictionaries for myspell/hunspell"
HOMEPAGE="https://sourceforge.net/projects/linguistico/"
SRC_URI="mirror://sourceforge/linguistico/Dizionari.IT_${PV}.oxt"

LICENSE="AGPL-3 GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	default
	# remove useless license files.
	rm -rf agpl3-en.txt gpl3-en.txt it_IT_license.txt \
		lgpl3-en.txt th_it_IT_copyright_licenza.txt \
		th_it_IT_lettera_in_inglese.txt || die
}
