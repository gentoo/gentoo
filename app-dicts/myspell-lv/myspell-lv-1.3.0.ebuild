# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"lv_LV.aff"
	"lv_LV.dic"
)

MYSPELL_HYPH=(
	"hyph_lv_LV.dic"
)

inherit myspell-r2

DESCRIPTION="Latvian dictionaries for myspell/hunspell"
HOMEPAGE="http://dict.dv.lv/home.php?prj=lv https://extensions.libreoffice.org/extensions/latviesu-valodas-pareizrakstibas-parbaudes-modulis"
SRC_URI="http://dict.dv.lv/download/lv_LV-${PV}.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

DEPEND="app-arch/unzip"
