# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font

DESCRIPTION="UmePlus fonts are modified Ume and M+ fonts for Japanese"
HOMEPAGE="http://www.geocities.jp/ep3797/modified_fonts_01.html"
SRC_URI="mirror://sourceforge.jp/users/10/10368/${P}.tar.xz"

LICENSE="mplus-fonts public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86 ~ppc-macos ~x86-macos"
IUSE=""
RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
