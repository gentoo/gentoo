# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYSPELL_DICT=(
	"pl_PL.aff"
	"pl_PL.dic"
)

inherit myspell-r2 unpacker

DESCRIPTION="Polish dictionaries for myspell/hunspell"
HOMEPAGE="https://sjp.pl/slownik/en/"
SRC_URI="https://sjp.pl/sl/ort/sjp-${P}.zip -> ${P}.zip"

LICENSE="CC-SA-1.0 Apache-2.0 LGPL-2.1+ GPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	default
	unpack_zip pl_PL.zip
}
