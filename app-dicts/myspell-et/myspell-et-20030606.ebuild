# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"latin-9/et_EE.aff"
	"latin-9/et_EE.dic"
)

MYSPELL_HYPH=(
	"hyph_et_EE.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Estonian dictionaries for myspell/hunspell"
HOMEPAGE="http://www.meso.ee/~jjpp/speller/"
SRC_URI="http://www.meso.ee/~jjpp/speller/ispell-et_${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

S="${WORKDIR}/ispell-et-${PV}"

src_prepare() {
	# naming handling to be inline with others
	mv hyph_et.dic hyph_et_EE.dic || die

}
