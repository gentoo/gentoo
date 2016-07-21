# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

DESCRIPTION="Sazanami Japanese TrueType fonts"
HOMEPAGE="http://efont.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/efont/10087/${P}.tar.bz2"

LICENSE="mplus-fonts public-domain" #446166
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

FONT_SUFFIX="ttf"

DOCS="README"

# Only installs fonts
RESTRICT="strip binchecks"

src_install() {
	font_src_install

	cd doc
	for d in oradano misaki mplus shinonome ayu kappa; do
		docinto $d
		dodoc $d/*
	done
}
