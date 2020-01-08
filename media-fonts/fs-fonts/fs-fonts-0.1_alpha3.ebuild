# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="${P/_alpha/test}"

DESCRIPTION="Japanese TrueType fonts designed for screen and print"
HOMEPAGE="http://x-tt.sourceforge.jp/fs_fonts/"
SRC_URI="mirror://sourceforge.jp/x-tt/7862/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}"

DOCS="AUTHORS *.txt THANKS Changes docs/README"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	dodoc -r docs/{kappa20,k14goth,mplus_bitmap_fonts,shinonome*,Oradano,kochi-substitute}
}
