# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="A subset seed design tool for DNA sequence alignment"
HOMEPAGE="http://bioinfo.lifl.fr/yass/iedera.php"
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
