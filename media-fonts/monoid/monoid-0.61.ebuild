# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Open source coding font"
HOMEPAGE="https://larsenwork.com/monoid/ https://github.com/larsenwork/monoid"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
DOCS=( Readme.md )
