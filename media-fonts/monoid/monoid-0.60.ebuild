# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit font multiprocessing

DESCRIPTION="Open source coding font"
HOMEPAGE="http://larsenwork.com/monoid https://github.com/larsenwork/monoid"
SRC_URI="https://github.com/larsenwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="media-gfx/fontforge[python]"
RDEPEND=""

FONT_SUFFIX="ttf"
FONT_S="${S}/_release"
DOCS="Readme.md"

src_compile() {
	local NJOBS=$(makeopts_jobs)
	for x in Source/*.sfdir; do
		Scripts/build.py ${NJOBS} ${NJOBS} $x
	done
}
