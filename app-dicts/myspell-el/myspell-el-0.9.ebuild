# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"el_GR.aff"
	"el_GR.dic"
)

MYSPELL_HYPH=(
	"hyph_el.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Greek dictionaries for myspell/hunspell"
HOMEPAGE="http://www.elspell.gr/"
SRC_URI="http://elspell.math.upatras.gr/files/ooffice/el_GR-${PV}.zip http://elspell.math.upatras.gr/files/ooffice/hyph_el.zip"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
