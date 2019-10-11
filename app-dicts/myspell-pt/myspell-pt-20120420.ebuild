# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"pt_PT.aff"
	"pt_PT.dic"
)

MYSPELL_HYPH=(
	"hyph_pt_PT.dic"
)

MYSPELL_THES=(
	"th_pt_PT.dat"
	"th_pt_PT.idx"
)

inherit myspell-r2

DESCRIPTION="Portuguese dictionaries for myspell/hunspell"
HOMEPAGE="http://natura.di.uminho.pt/wiki/doku.php?id=dicionarios:main"
# The dicts are not versioned.
# Version is determined by its date of upload to the server.
# Check at: http://darkstar.ist.utl.pt/openoffice.org/pt/
SRC_URI="
	http://darkstar.ist.utl.pt/openoffice.org/pt/oo3x-pt-PT.oxt
	preao? ( http://darkstar.ist.utl.pt/openoffice.org/pt/oo3x-pt-PT-preao.oxt )
"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE="+preao"
