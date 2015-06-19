# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/fs-fonts/fs-fonts-0.1_alpha3.ebuild,v 1.14 2014/03/02 09:37:33 pacho Exp $

inherit font

IUSE=""
MY_P="${P/_alpha/test}"

DESCRIPTION="Japanese TrueType fonts designed for screen and print"
HOMEPAGE="http://x-tt.sourceforge.jp/fs_fonts/"
SRC_URI="mirror://sourceforge.jp/x-tt/7862/${MY_P}.tar.gz"

KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
LICENSE="public-domain"
SLOT=0

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="AUTHORS *.txt THANKS Changes docs/README"

# Only installs fonts
RESTRICT="strip binchecks"

src_install() {
	font_src_install

	cd docs
	for d in kappa20 k14goth mplus_bitmap_fonts shinonome* Oradano kochi-substitute; do
		docinto $d
		dodoc $d/*
	done
}
