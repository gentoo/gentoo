# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-1.1.ebuild,v 1.3 2012/12/16 16:31:21 ulm Exp $

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/research/linux/atomic_ops/download/${P}.tar.gz"

LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="~amd64 -x86 -x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake pkgdatadir="/usr/share/doc/${PF}" DESTDIR="${D}" install
}
