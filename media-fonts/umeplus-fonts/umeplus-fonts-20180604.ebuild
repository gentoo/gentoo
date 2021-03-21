# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Modified Ume and M+ fonts for Japanese"
HOMEPAGE="http://linuxplayers.g1.xrea.com/modified_fonts_01.html"
SRC_URI="https://free.nchc.org.tw/osdn//users/21/21734/${P}.tar.xz"

LICENSE="mplus-fonts public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"
IUSE=""
RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
