# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"eo_l3.aff"
	"eo_l3.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Esperanto dictionaries for myspell/hunspell"
HOMEPAGE="http://nlp.fi.muni.cz/projekty/esperanto_spell_checker/"
SRC_URI="mirror://sourceforge/aoo-extensions/3377/1/${PV}-dev.oxt -> ${P}.oxt"

LICENSE="GPL-2 LGPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

src_prepare() {
	default

	# move the dicts for nicer name
	mv literumilo.aff eo_l3.aff || die
	mv literumilo.dic eo_l3.dic || die
}
