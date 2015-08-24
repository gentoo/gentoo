# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Directory hierarchy mapping tool from FreeBSD"
HOMEPAGE="https://code.google.com/p/mtree-port/"
SRC_URI="https://mtree-port.googlecode.com/files/${P}.tar.gz"

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
