# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"gl_ES.aff"
	"gl_ES.dic"
)

MYSPELL_HYPH=(
	"hyph_gl_ES.dic"
)

MYSPELL_THES=(
	"thes_gl_ES.dat"
	"thes_gl_ES.idx"
)

inherit myspell-r2

DESCRIPTION="Galician dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/corrector-ortografico-para-galego"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/corrector-18-07-para-galego.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

DOCS=( changelog.txt package-description.txt readme.txt readme-gl.txt readme_hyph-gl.txt readme_th_gl.txt )

src_prepare() {
	default
	# Naming correctly
	mv gl.aff gl_ES.aff || die
	mv gl.dic gl_ES.dic || die
	mv hyph_gl.dic hyph_gl_ES.dic || die
	mv thesaurus_gl.dat thes_gl_ES.dat || die
	mv thesaurus_gl.idx thes_gl_ES.idx || die
}
