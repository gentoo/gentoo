# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Measure the read time per sector on CD or DVD to check the quality"
HOMEPAGE="http://swaj.net/unix/index.html#cdck"
SRC_URI="http://swaj.net/unix/cdck/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	default

	sed -e '1d' -i man/cdck_man.in || die "sed failed"
}

src_configure() {
	econf --disable-dependency-tracking \
		--disable-shared
}

src_install() {
	default

	dobin src/cdck
	doman man/cdck.1
}
