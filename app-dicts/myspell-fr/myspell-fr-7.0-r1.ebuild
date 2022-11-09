# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	# Classique (the recommended variant)
	# FR region hack to deal with LibreOffice bug, see src_prepare
	"fr_FR.aff"
	"fr_FR.dic"
	# Reforme 1990 = the reformed orthography
	"fr-1990.aff"
	"fr-1990.dic"
	# Toutes variantes = Classique + Reforme
	"fr-ttsvars.aff"
	"fr-ttsvars.dic"
)

MYSPELL_HYPH=(
	# FR region hack to deal with LibreOffice bug, see src_prepare
	"hyph_fr_FR.dic"
)

MYSPELL_THES=(
	# FR region hack to deal with LibreOffice bug, see src_prepare
	"th_fr_FR_v2.dat"
	"th_fr_FR_v2.idx"
)

inherit myspell-r2

DESCRIPTION="French dictionaries for myspell/hunspell"
HOMEPAGE="https://grammalecte.net/home.php?prj=fr"
SRC_URI="https://grammalecte.net/grammalecte/oxt/lo-oo-ressources-linguistiques-fr-v${PV}.oxt"

LICENSE="MPL-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-linux"
IUSE=""

src_prepare() {
	# Renaming so that variant subtags follow bcp47 rules
	# <https://tools.ietf.org/html/rfc5646#section-2.1>,
	# as this gives a nicer presentation in Firefox
	# (due to it following bcp47 rules)
	#
	# fr-classique is recommended so rename to fr
	mv fr-classique.aff fr.aff || die
	mv fr-classique.dic fr.dic || die
	# fr-reforme1990 changed to fr-1990 similarly to de-1901 and de-1996
	mv fr-reforme1990.aff fr-1990.aff || die
	mv fr-reforme1990.dic fr-1990.dic || die
	# fr-toutesvariantes changed to fr-ttsvars until we find something better
	mv fr-toutesvariantes.aff fr-ttsvars.aff || die
	mv fr-toutesvariantes.dic fr-ttsvars.dic || die

	# To deal with LibreOffice bug
	# https://bugs.documentfoundation.org/show_bug.cgi?id=64830
	# we need dictionary/thesaurus/hyphenation files named fr_FR
	# (or should that be fr-FR?), so we rename the recommended one fr here.
	# This is hopefully temporary, so we keep this separate from
	# the bcp47-ification above.
	mv fr.aff fr_FR.aff || die
	mv fr.dic fr_FR.dic || die
	mv hyph_fr.dic hyph_fr_FR.dic || die
	# thes -> th and extra v2 suffix, again to appease LibreOffice
	mv thes_fr.dat th_fr_FR_v2.dat || die
	mv thes_fr.idx th_fr_FR_v2.idx || die

	eapply_user
}

DOCS=( package-description.txt README_dict_fr.txt README_hyph_fr-2.9.txt README_hyph_fr-3.0.txt README_thes_fr.txt )
