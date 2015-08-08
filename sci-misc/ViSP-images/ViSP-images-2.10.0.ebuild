# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="ViSP images data set"
HOMEPAGE="http://www.irisa.fr/lagadic/visp/"
SRC_URI="http://www.irisa.fr/lagadic/visp/download/sequence/ViSP-images-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
S="${WORKDIR}/${PN}"

src_install() {
	dodoc README ChangeLog
	rm -f README LICENSE.txt ChangeLog
	dodir /usr/share/visp-images-data/
	mv "${S}" "${ED}/usr/share/visp-images-data/"
}
