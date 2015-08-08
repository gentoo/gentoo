# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit font

DESCRIPTION="UmePlus fonts are modified Ume and M+ fonts for Japanese"
HOMEPAGE="http://www.geocities.jp/ep3797/modified_fonts_01.html"
SRC_URI="mirror://sourceforge/mdk-ut/${P}.tar.lzma"

LICENSE="mplus-fonts public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x86-macos"
IUSE=""
RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DOCS=( ChangeLog README )
