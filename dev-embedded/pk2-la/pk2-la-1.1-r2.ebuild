# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/pk2-la/pk2-la-1.1-r2.ebuild,v 1.1 2015/03/21 15:06:20 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Logic Analyzer and I/O Probe for the Microchip PICkit2"
HOMEPAGE="http://sourceforge.net/projects/pk2-la"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyusb:0[${PYTHON_USEDEP}]
	"

src_compile() { :; }

src_install() {
	python_foreach_impl python_doscript ${PN}

	dodoc README LA-Format IO-Format CHANGELOG
}
