# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"id_ID.aff"
	"id_ID.dic"
)

MYSPELL_HYPH=(
	"hyph_id_ID.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Indonesian dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/indonesian-dictionary-kamus-indonesia-by-benitius"
SRC_URI="https://extensions.libreoffice.org/extension-center/indonesian-dictionary-kamus-indonesia-by-benitius/releases/${PV}/id_id.oxt -> ${P}.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE=""
