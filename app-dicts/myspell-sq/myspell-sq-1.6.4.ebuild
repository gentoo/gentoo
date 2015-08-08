# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"sq_AL.dic"
	"sq_AL.aff"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Albanian dictionaries for myspell/hunspell"
HOMEPAGE="http://www.shkenca.org/k6i/albanian_dictionary_for_myspell_en.html"
SRC_URI="http://www.shkenca.org/shkarkime/${PN}_AL-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${PN}_AL-${PV}"
