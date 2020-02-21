# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX2e macros to prepare manuscripts for the journals of the APS and AIP"
HOMEPAGE="https://journals.aps.org/revtex"
SRC_URI="http://mirrors.ctan.org/macros/latex/contrib/revtex.zip -> ${P}.zip"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=dev-texlive/texlive-latex-2012"
DEPEND="${RDEPEND}
	app-arch/unzip
"

IUSE="doc"

S="${WORKDIR}/${PN}"

TEXMF=/usr/share/texmf-site

src_prepare(){
	default
	find "${S}" -name '*4-1*' -delete || die
	find "${S}" -name reftest4-2.tex -delete || die
}

src_compile(){
	cd "${S}/source" || die

	for name in *.dtx; do
		tex $name || die
	done
	latex-package_src_compile

	cd "${S}/bibtex" || die
	latex-package_src_compile
}

src_install() {
	cd "${S}/source"

	use doc && rm -f aip.dtx # fails to build docs

	latex-package_src_install

	# we need the revtex-specific rtx files in the same dir as the class files
	insinto ${TEXMF}/tex/latex/${PN}
	for i in `find . -maxdepth 1 -type f -name "*.rtx"` ; do
		doins $i
	done

	cd "${S}/bibtex" || die
	latex-package_src_install

	find "${D}" -name aip4-1.rtx -delete || die
}
