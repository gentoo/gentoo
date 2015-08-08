# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Altivec enabled libc memory function"
HOMEPAGE="http://freevec.org"
SRC_URI="http://www.codex.gr/system/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE=""

DEPEND=">=sys-devel/gcc-4.2"
RDEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

}
src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc TODO README INSTALL
}
