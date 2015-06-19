# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/remake/remake-3.82.0.4.ebuild,v 1.2 2011/11/30 04:21:39 vapier Exp $

MY_P="${PN}-${PV:0:4}+dbg-${PV:5}"

DESCRIPTION="patched version of GNU make that adds improved error reporting, tracing, and a debugger"
HOMEPAGE="http://bashdb.sourceforge.net/remake/"
SRC_URI="mirror://sourceforge/bashdb/${MY_P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline"

RDEPEND="readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS INSTALL NEWS README
	# fix collide with the real make's info pages
	rm -f "${D}"/usr/share/info/make.*
}
