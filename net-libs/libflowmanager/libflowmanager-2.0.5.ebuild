# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A library that measures and reports on packet flows"
HOMEPAGE="http://research.wand.net.nz/software/libflowmanager.php"
SRC_URI="http://research.wand.net.nz/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	>=net-libs/libtrace-3.0.6
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	econf $(use_enable static-libs static)
}
