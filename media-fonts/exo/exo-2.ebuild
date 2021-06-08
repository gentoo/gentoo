# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Geometric sans-serif font with a technological feel"
HOMEPAGE="https://www.ndiscover.com/exo-2-0/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.tar.xz"
# repackaged from two upstream zips (exo-2, exo condensed & expanded) + license

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

FONT_SUFFIX="otf"
