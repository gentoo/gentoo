# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ViSP images data set"
HOMEPAGE="http://www.irisa.fr/lagadic/visp/"
SRC_URI="http://visp-doc.inria.fr/download/dataset/visp-images-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/visp-images-${PV}"

src_install() {
	dodoc README.md
	rm -f README.md LICENSE.txt
	dodir /usr/share/visp-images-data/
	mv "${S}" "${ED}/usr/share/visp-images-data/${PN}"
}
