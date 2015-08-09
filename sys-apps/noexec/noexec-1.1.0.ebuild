# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="a package for preventing processes from using exec system calls"
HOMEPAGE="http://noexec.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=sys-libs/glibc-2.3.2-r9"

src_install() {
	make install DESTDIR=${D} || die "installation failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README
}
