# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/rvm/rvm-1.16.ebuild,v 1.1 2009/06/28 11:54:05 patrick Exp $

DESCRIPTION="Recoverable Virtual Memory (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/rvm/src/${P}.tar.gz"
IUSE=""
SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"

DEPEND=">=sys-libs/lwp-2.0
	sys-apps/grep
	sys-devel/libtool
	sys-devel/gcc"

RDEPEND=">=sys-libs/lwp-2.0"

src_install() {
	make DESTDIR="${D}" install || die

	dodoc NEWS
}
