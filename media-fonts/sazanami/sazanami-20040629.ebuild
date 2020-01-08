# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Sazanami Japanese TrueType fonts"
HOMEPAGE="http://efont.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/efont/10087/${P}.tar.bz2"

LICENSE="mplus-fonts public-domain" #446166
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
# Only installs fonts
RESTRICT="strip binchecks"

DOCS="README"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	dodoc -r doc/{oradano,misaki,mplus,shinonome,ayu,kappa}
}
