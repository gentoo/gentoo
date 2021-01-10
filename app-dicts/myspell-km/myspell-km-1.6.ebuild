# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"km_KH.aff"
	"km_KH.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Khmer dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/khmer-spelling-checker-sbbic-version"
SRC_URI="https://extensions.libreoffice.org/extension-center/khmer-spelling-checker-sbbic-version/releases/${PV}/sbbic-khmer-spelling-checker-${PV}.oxt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE=""
