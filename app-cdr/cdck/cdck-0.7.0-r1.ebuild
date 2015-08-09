# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Measure the read time per sector on CD or DVD to check the quality"
HOMEPAGE="http://swaj.net/unix/index.html#cdck"
SRC_URI="http://swaj.net/unix/cdck/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -e '1d' -i man/cdck_man.in || die "sed failed"
}

src_configure() {
	econf --disable-dependency-tracking \
		--disable-shared || die "econf failed."
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install() {
	dobin src/cdck || die "dobin failed."
	doman man/cdck.1
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
