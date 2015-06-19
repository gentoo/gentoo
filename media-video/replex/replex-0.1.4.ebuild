# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/replex/replex-0.1.4.ebuild,v 1.3 2006/12/31 18:11:41 beandog Exp $

inherit eutils

DESCRIPTION="REPLEX remuxes MPEG-2 transport streams into program streams"
HOMEPAGE="http://www.metzlerbros.org/dvb/"
SRC_URI="http://www.metzlerbros.org/dvb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	emake CFLAGS="${CFLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE" || die "emake failed"
}

src_install() {
	dobin replex
	dodoc README CHANGES TODO
}
