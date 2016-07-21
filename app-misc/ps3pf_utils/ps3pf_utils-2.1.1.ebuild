# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic

DESCRIPTION="Utilities to set the ps3 specific features"
HOMEPAGE="http://www.playstation.com/ps3-openplatform/index.html"
#SRC_URI="http://www.powerdeveloper.org/files/Cell/SourceCD/${P}.tar.bz2
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE=""

# fixme: depend on a version of sys-kernel/linux-headers that supports ps3

src_install() {
	emake DESTDIR="${D}" install || die
}
