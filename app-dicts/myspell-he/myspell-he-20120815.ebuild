# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"he_IL.aff"
	"he_IL.dic"
)

inherit myspell-r2

DESCRIPTION="Hebrew dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/hebrew-he-spell-check-dictionary"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/dict-he-2012-08-15.oxt"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
