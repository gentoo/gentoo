# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"nb_NO.aff"
	"nb_NO.dic"
)

MYSPELL_HYPH=(
	"hyph_nb_NO.dic"
)

MYSPELL_THES=(
	"th_nb_NO_v2.dat"
	"th_nb_NO_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Norwegian dictionaries for myspell/hunspell"
HOMEPAGE="http://spell-norwegian.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/2357/no_NO-pack2-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

src_unpack() {
	default
	myspell-r2_src_unpack

	for i in *.zip; do
		unzip ${i} || die
	done
}
