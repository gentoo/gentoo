# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV::4}-${PV:4:2}-${PV:6}

MYSPELL_DICT=(
	"ia.aff"
	"ia.dic"
)

MYSPELL_HYPH=(
	"ia-hyph.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Interlingua dictionaries for myspell/hunspell"
LICENSE="GPL-3"
HOMEPAGE="https://extensions.openoffice.org/en/project/interlingua-dictionario-orthographic-e-regulas-de-division-de-parolas"
SRC_URI="mirror://sourceforge/aoo-extensions/dict-ia-${MY_PV}.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
