# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"fr-moderne.aff"
	"fr-moderne.dic"
	"fr-classique.aff"
	"fr-classique.dic"
	"fr_FR.aff"
	"fr_FR.dic"
	"fr-reforme1990.aff"
	"fr-reforme1990.dic"
)

MYSPELL_HYPH=(
	"hyph_fr_FR_v3.dic"
)

MYSPELL_THES=(
	"th_fr_FR_v3.dat"
	"th_fr_FR_v3.idx"
)

inherit myspell-r2

DESCRIPTION="French dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/dictionnaires-francais"
SRC_URI="
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-moderne-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-classique-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-classique-reforme1990-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-reforme1990-v${PV}.oxt
"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-linux ~x86-macos"
IUSE=""

src_prepare() {
	default
	# the default should be classique+reforme1990
	# renaming to fr_FR
	mv fr-classique+reforme1990.aff fr_FR.aff || die
	mv fr-classique+reforme1990.dic fr_FR.dic || die

	# move the hyphen/thes to common used name
	# versions determined from README files
	mv hyph_fr.dic hyph_fr_FR_v3.dic || die
	mv thes_fr.dat th_fr_FR_v3.dat || die
	mv thes_fr.idx th_fr_FR_v3.idx || die
}
