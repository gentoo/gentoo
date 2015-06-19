# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/bera/bera-20040930.ebuild,v 1.3 2009/12/15 00:23:44 rich0 Exp $

inherit latex-package

MY_P=${PN}
S=${WORKDIR}/${MY_P}
SUPPLIER="public"
DESCRIPTION="LaTeX package for the Bera Type1 font family"
HOMEPAGE="http://www.ctan.org/tex-archive/fonts/bera/"
SRC_URI="mirror://gentoo/${P}.zip"
LICENSE="LPPL-1.2"

DEPEND="app-arch/unzip"

KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	unzip ${MY_P}.zip
}

src_install() {
	DOCS="${S}/README ${S}/LICENSE ${S}/doc/fonts/bera/bera.txt"
	# install sty and fonts
	cd "${S}/tex/latex/${MY_P}"
	latex-package_src_install

	cd "${S}/fonts/vf/public/${MY_P}"
	latex-package_src_install

	cd "${S}/fonts/tfm/public/${MY_P}"
	latex-package_src_install

	# install map
	cd "${S}"
	dodir ${TEXMF}/fonts/map/dvips/${MY_P}
	cp -pPR fonts/map/dvips/${MY_P}.map "${D}${TEXMF}/fonts/map/dvips/${MY_P}"

	latex-package_src_install
}

pkg_postinst() {
	latex-package_rehash
	updmap-sys --enable Map ${MY_P}.map
}

pkg_postrm() {
	updmap-sys --disable ${MY_P}.map
}
