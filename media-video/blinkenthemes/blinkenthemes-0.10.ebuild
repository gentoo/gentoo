# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Themes for blinkensim"
HOMEPAGE="http://www.blinkenlights.net/project/developer-tools"
SRC_URI="http://www.blinkenlights.de/dist/blinkenthemes-0.10.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-libs/blib
	virtual/pkgconfig"
RDEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" \
		install || die "install failed"
}
