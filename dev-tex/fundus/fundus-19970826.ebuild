# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

S=${WORKDIR}/${PN}
DESCRIPTION="Providing LaTeX access to various font families"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/fundus.html"
# Taken from: ftp://ftp.dante.de/tex-archive/macros/latex/contrib/gene/fundus.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/twcal.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/va.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/la.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/calligra.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}-fonts.tar.gz"
IUSE=""
SLOT="0"
LICENSE="LPPL-1.3c"
KEYWORDS="x86 ~amd64 ~sparc ~ppc"

src_unpack() {
	unpack ${A}
	cd ${S}
	for i in *.tar.gz ; do
		tar xzf $i
	done
}

src_install() {
	latex-package_src_install

	for f in va la twcal calligra ; do
		pushd $f
		insinto /usr/share/texmf/fonts/source/public/$f
		doins *.mf
		popd
	done
}
