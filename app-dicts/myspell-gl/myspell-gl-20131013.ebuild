# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"gl_ES.aff"
	"gl_ES.dic"
)

MYSPELL_HYPH=(
	"hyph_gl.dic"
)

MYSPELL_THES=(
	"thesaurus_gl.dat"
	"thesaurus_gl.idx"
)

inherit myspell-r2

DESCRIPTION="Galician dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="https://extensions.openoffice.org/en/project/corrector-ortografico-hunspell-para-galego"
SRC_URI="mirror://sourceforge/aoo-extensions/hunspell-gl-13.10.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
