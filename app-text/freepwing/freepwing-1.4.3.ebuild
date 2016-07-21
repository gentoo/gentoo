# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE=""

DESCRIPTION="FreePWING is a free JIS X 4081 (subset of EPWING V1) formatter"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/freepwing/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/freepwing/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="dev-lang/perl"

src_install() {
	emake install DESTDIR="${D}" \
		perllibdir=`perl -V:vendorlib | cut -d\' -f2` \
		pkgdocdir=/usr/share/doc/${PF} || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
