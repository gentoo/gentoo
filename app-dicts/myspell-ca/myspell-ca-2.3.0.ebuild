# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"ca_ES.aff"
	"ca_ES.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Catalan dictionaries for myspell/hunspell"
HOMEPAGE="http://www.softcatala.org/wiki/Rebost:Corrector_ortogr%C3%A0fic_de_catal%C3%A0_%28general%29_per_a_l%27OpenOffice.org"
SRC_URI="http://www.softcatala.org/diccionaris/actualitzacions/OOo/catalan.oxt -> ${P}.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_prepare() {
	# rename to conform the common naming scheme
	mv catalan.aff ca_ES.aff || die
	mv catalan.dic ca_ES.dic || die

	# remove licenses
	rm -rf LICENSES-en.txt LLICENCIES-ca.txt || die
}
