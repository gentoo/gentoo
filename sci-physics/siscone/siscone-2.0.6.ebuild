# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/siscone/siscone-2.0.6.ebuild,v 1.1 2013/06/04 16:36:09 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Hadron Seedless Infrared-Safe Cone jet algorithm"
HOMEPAGE="http://siscone.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{cpp,h}
		insinto /usr/share/doc/${PF}/examples/events
		doins examples/events/*.dat
	fi
}
