# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"de_DE_1901.aff"
	"de_DE_1901.dic"
)

MYSPELL_HYPH=(
	"hyph_de_DE_1901.dic"
)

inherit myspell-r2

DESCRIPTION="German (traditional orthography) dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/german-de-de-1901-old-spelling-dictionaries"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/dict-de-de-1901-oldspell-2017-06-22.oxt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	default
	# Nicely rename; http://www.iana.org/assignments/language-subtag-registry
	mv de_DE_OLDSPELL.aff de_DE_1901.aff || die
	mv de_DE_OLDSPELL.dic de_DE_1901.dic || die
	mv hyph_de_DE_OLDSPELL.dic hyph_de_DE_1901.dic || die
	# Remove thesaurus for new spelling to avoid installing its readme file
	rm th_de_DE_v2* || die
}
