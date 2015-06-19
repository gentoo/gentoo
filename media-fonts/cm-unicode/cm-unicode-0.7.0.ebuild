# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cm-unicode/cm-unicode-0.7.0.ebuild,v 1.2 2012/05/27 13:18:06 yngwin Exp $

EAPI=3

inherit font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://cm-unicode.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-ttf.tar.xz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND=""

FONT_SUFFIX="ttf"
DOCS="Changes FAQ"
