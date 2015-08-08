# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="almost lossless JPEG pixel interpolator, for correcting digital camera defects"
HOMEPAGE="http://www.zero-based.org/software/jpegpixi/"
SRC_URI="http://www.zero-based.org/software/jpegpixi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="virtual/jpeg"

src_install() {
	dobin jpegpixi jpeghotp || die
	doman man/jpegpixi.1 man/jpeghotp.1
	dodoc AUTHORS NEWS README README.jpeglib ChangeLog
}
