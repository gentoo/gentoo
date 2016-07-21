# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A library that performs application layer protocol identification for flows"
HOMEPAGE="http://research.wand.net.nz/software/libprotoident.php"
SRC_URI="http://research.wand.net.nz/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs +tools"

DEPEND="
	>=net-libs/libtrace-3.0.7
	tools? ( net-libs/libflowmanager )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	econf $(use_with tools)
}
