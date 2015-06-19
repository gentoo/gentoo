# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/biogrep/biogrep-1.0.ebuild,v 1.1 2010/06/04 21:59:31 hwoarang Exp $

DESCRIPTION="Multithreading application for matching large sets of patterns
against biosequence dbs."
HOMEPAGE="http://web.mit.edu/bamel/biogrep.shtml"
SRC_URI="http://web.mit.edu/bamel/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake prefix="${D}"/usr install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
