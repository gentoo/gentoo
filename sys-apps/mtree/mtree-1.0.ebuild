# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mtree/mtree-1.0.ebuild,v 1.1 2012/07/01 16:44:39 ryao Exp $

EAPI=4

DESCRIPTION="Directory hierarchy mapping tool from FreeBSD"
HOMEPAGE="http://code.google.com/p/mtree-port/"
SRC_URI="http://mtree-port.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install()
{

	default_src_install

	# Avoid conflict with app-arch/libarchive
	rm "${ED}usr/share/man/man5/mtree.5"

}
