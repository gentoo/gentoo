# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MYSPELL_DICT=(
	"kk_KZ.aff"
	"kk_KZ.dic"
	"kk_noun_adj.aff"
	"kk_noun_adj.dic"
	"kk_test.aff"
	"kk_test.dic"
)

inherit myspell-r2

DESCRIPTION="Kazakh dictionaries for myspell/hunspell"
HOMEPAGE="https://github.com/kergalym/myspell-kk"
SRC_URI="https://github.com/kergalym/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}" # override eclass assignment
RDEPEND="!app-dicts/hunspell-kk"
