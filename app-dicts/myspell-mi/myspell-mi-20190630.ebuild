# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"mi_NZ.aff"
	"mi_NZ.dic"
)

inherit myspell-r2

DESCRIPTION="Maori dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="https://www.openoffice.org/lingucomponent/"
SRC_URI="https://github.com/scardracs/gentoo-packages/releases/download/mi-${PV}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
