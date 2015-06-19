# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/yass/yass-1.14.ebuild,v 1.1 2010/06/18 05:52:46 weaver Exp $

EAPI="2"

DESCRIPTION="Genomic similarity search with multiple transition constrained spaced seeds"
HOMEPAGE="http://bioinfo.lifl.fr/yass/"
SRC_URI="http://bioinfo.lifl.fr/yass/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_install() {
	einstall || die
	dodoc AUTHORS README NEWS
}
