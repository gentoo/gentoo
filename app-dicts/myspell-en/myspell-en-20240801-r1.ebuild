# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit myspell-r2

DESCRIPTION="English dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extensions/english-dictionaries
	https://github.com/marcoagpinto/aoo-mozilla-en-dict
	https://proofingtoolgui.org
"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/41/1722502287/dict-en-20240801_lo.oxt"

LICENSE="BSD MIT LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

src_prepare() {
	local PLOCALES=( "en_AU" "en_CA" "en_GB" "en_US" "en_ZA" )
	# This thesaurus is used by all the English dictionaries, see
	# ./dictionaries.xcu in the distfile, lines 71-81.
	MYSPELL_THES=(
		"th_en_US_v2.dat"
		"th_en_US_v2.idx"
	)

	for lang in "${PLOCALES[@]}"; do
		MYSPELL_DICT+=( "${lang}.aff" "${lang}.dic" )
	done

	MYSPELL_HYPH=(
		"hyph_en_US.dic"
		"hyph_en_GB.dic"
	)

	default
}
