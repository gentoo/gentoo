# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

MY_P="calendar"

DESCRIPTION="LaTeX package used to create Calendars.  Very flexible and robust"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/calendar/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="amd64 ppc sparc x86"

LICENSE="LaTeX-Calendar"
SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	debug-print function $FUNCNAME $*
	echo "Extracting from allcal.ins"
	( yes | latex allcal.ins ) >/dev/null 2>&1 || die "extracting failed"
}

src_install() {
	texi2dvi -q -c --language=latex calguide.tex &> /dev/null || die "conversion failed"

	latex-package_src_doinstall styles fonts bin dvi

	dodoc README MANIFEST CATALOG
	docinto samples
	dodoc bigdemo.tgz *.cfg *.tex *.cld
}
