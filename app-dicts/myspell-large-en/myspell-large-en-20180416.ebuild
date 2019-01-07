# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV=${PV:0:4}.${PV:4:2}.${PV:6:2}

inherit myspell-r2

DESCRIPTION="English Large dictionaries for myspell/hunspell"
HOMEPAGE="https://sourceforge.net/projects/wordlist/"
SRC_URI="https://versaweb.dl.sourceforge.net/project/wordlist/speller/${MY_PV}/hunspell-en_AU-large-${MY_PV}.zip
		https://versaweb.dl.sourceforge.net/project/wordlist/speller/${MY_PV}/hunspell-en_CA-large-${MY_PV}.zip
		https://versaweb.dl.sourceforge.net/project/wordlist/speller/${MY_PV}/hunspell-en_GB-large-${MY_PV}.zip
		https://versaweb.dl.sourceforge.net/project/wordlist/speller/${MY_PV}/hunspell-en_US-large-${MY_PV}.zip"
LICENSE="myspell-en_CA-KevinAtkinson public-domain Princeton Ispell"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PLOCALES=( "en" "en-AU" "en-CA" "en-GB" "en-US" )
IUSE+="${PLOCALES[@]/#/l10n_}"
REQUIRED_USE="|| ( ${IUSE[@]} )"

src_prepare() {
	default

	MYSPELL_DICT=( )
	for lang in "${PLOCALES[@]}"; do
		if [[ "${lang}" == "en" ]]; then
			continue
		fi
		local mylinguas="${lang//-/_}-large"
		if use "l10n_${lang}" || use l10n_en; then
			MYSPELL_DICT+=( "${mylinguas}.aff" "${mylinguas}.dic" )
		else
			rm "README_${mylinguas}.txt" || die
		fi
	done
}
