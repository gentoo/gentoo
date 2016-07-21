# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A replacement for libcrypt with DES, MD5 and blowfish support"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.suse.de/us/private/products/suse_linux/i386/packages_personal/libxcrypt.html"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
}
