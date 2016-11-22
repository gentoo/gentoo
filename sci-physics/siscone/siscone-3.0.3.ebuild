# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Hadron Seedless Infrared-Safe Cone jet algorithm"
HOMEPAGE="http://siscone.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if use examples; then
		docinto examples
		dodoc examples/*.{cpp,h}
		docinto examples/events
		dodoc examples/events/*.dat
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
