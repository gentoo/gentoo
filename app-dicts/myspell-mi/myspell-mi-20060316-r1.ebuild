# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"mi_NZ.aff"
	"mi_NZ.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Maori dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/myspell-mi_NZ-${PV}.zip"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE=""
