# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit latex-package

S="${WORKDIR}/${PN}"
LICENSE="LPPL-1.2"
DESCRIPTION="A LaTeX module to format envelopes"
HOMEPAGE="https://ctan.org/pkg/envlab"
# downloaded from
# ftp://ftp.ctan.org/pub/tex-archive/macros/latex/contrib/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
SLOT="0"
DEPEND=""
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

TEXMF=/usr/share/texmf-site

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	ebegin "Compiling ${PN}"
	latex envlab.ins || die
	pdflatex elguide.tex || die
	pdflatex elguide.tex || die
	pdflatex envlab.drv || die
	pdflatex envlab.drv || die
	eend
}

src_install() {
	latex-package_src_install

	insinto ${TEXMF}/tex/latex/${PN}
	doins *.cfg

	dodoc readme.v12
}
