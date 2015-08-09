# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

IUSE=""

DESCRIPTION="Japanese bitmap fonts for X"
SRC_URI="http://openlab.jp/efont/dist/shinonome/${P}.tar.bz2"
HOMEPAGE="http://openlab.jp/efont/shinonome/"

LICENSE="public-domain"
SLOT=0
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DEPEND="x11-apps/bdftopcf"
RDEPEND=""

FONT_SUFFIX="pcf.gz"
FONT_S=${S}
DOCS="AUTHORS BUGS ChangeLog* DESIGN* INSTALL LICENSE README THANKS TODO"

# Only installs fonts
RESTRICT="strip binchecks"

src_compile(){
	econf --with-pcf --without-bdf || die
	emake || die

	for i in *.pcf ; do
		gzip -9 $i
	done
}
