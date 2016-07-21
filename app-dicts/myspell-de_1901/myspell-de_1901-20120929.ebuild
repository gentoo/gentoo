# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYSPELL_DICT=(
	"de_DE_1901.aff"
	"de_DE_1901.dic"
)

MYSPELL_HYPH=(
	"hyph_de_DE_1901.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="German (traditional orthography) dictionaries for myspell/hunspell"
HOMEPAGE="http://www.j3e.de/myspell/
	http://extensions.libreoffice.org/extension-center/german-de-de-1901-old-spelling-dictionaries"
SRC_URI="http://extensions.libreoffice.org/extension-center/german-de-de-1901-old-spelling-dictionaries/pscreleasefolder.2011-11-04.1209635399/${PV:0:4}.${PV:4:2}.${PV:6:2}/dict-de_de-1901_oldspell_${PV:0:4}-${PV:4:2}-${PV:6:2}.oxt"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"

src_prepare() {
	# Nicely rename; http://www.iana.org/assignments/language-subtag-registry
	mv de_DE_OLDSPELL.aff de_DE_1901.aff || die
	mv de_DE_OLDSPELL.dic de_DE_1901.dic || die
	mv hyph_de_DE_OLDSPELL.dic hyph_de_DE_1901.dic || die
	# Remove thesaurus for new spelling to avoid installing its readme file
	rm th_de_DE_v2* || die
}
