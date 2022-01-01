# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"sk_SK.aff"
	"sk_SK.dic"
)

MYSPELL_HYPH=(
	"hyph_sk_SK.dic"
)

MYSPELL_THES=(
	"th_sk_SK_v2.dat"
	"th_sk_SK_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Slovak dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/874"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/84/slovak-dictionaries-2020-05.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
