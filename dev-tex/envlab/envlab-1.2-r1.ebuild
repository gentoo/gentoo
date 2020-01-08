# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="A LaTeX module to format envelopes"
HOMEPAGE="https://ctan.org/pkg/envlab"
# downloaded from:
# ftp://ftp.ctan.org/pub/tex-archive/macros/latex/contrib/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

LICENSE="LPPL-1.2"
SLOT="0"
IUSE=""

DEPEND=""

TEXMF=/usr/share/texmf-site

S="${WORKDIR}/${PN}"

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	ebegin "Compiling ${PN}"
	latex envlab.ins || die "compiling #1 failed"
	pdflatex elguide.tex || die "compiling #2 failed"
	pdflatex elguide.tex || die "compiling #2 failed"
	pdflatex envlab.drv || die "compiling #3 failed"
	pdflatex envlab.drv || die "compiling #3 failed"
	eend
}

src_install() {
	latex-package_src_install

	insinto ${TEXMF}/tex/latex/${PN}
	doins *.cfg

	dodoc readme.v12
}
