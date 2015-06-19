# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/goosh/goosh-1.3.ebuild,v 1.4 2009/02/23 05:54:03 darkside Exp $

DESCRIPTION="Small process-control library for Guile"
HOMEPAGE="http://arglist.com/guile/"
SRC_URI="http://arglist.com/guile/${P}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""
RDEPEND=">=dev-scheme/guile-1.6"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
