# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/remake/remake-3.81.0.3.ebuild,v 1.1 2010/05/08 17:14:09 vapier Exp $

MY_P="${PN}-${PV:0:4}+dbg-${PV:5}"

DESCRIPTION="patched version of GNU make that adds improved error reporting, tracing, and a debugger"
HOMEPAGE="http://bashdb.sourceforge.net/remake/"
SRC_URI="mirror://sourceforge/bashdb/${MY_P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS INSTALL NEWS README
	# fix collide with the real make's info pages
	rm -f "${D}"/usr/share/info/make.*
}
