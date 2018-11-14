# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="gbdfed Bitmap Font Editor"
HOMEPAGE="http://sofia.nmsu.edu/~mleisher/Software/gbdfed/"
SRC_URI="http://sofia.nmsu.edu/~mleisher/Software/gbdfed/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6:2
	>=media-libs/freetype-2
	x11-libs/libX11
	x11-libs/pango"
DEPEND="${RDEPEND}"

src_prepare() {
	sed "s:-D.*_DISABLE_DEPRECATED::" -i Makefile.in || die #248562
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS
}
