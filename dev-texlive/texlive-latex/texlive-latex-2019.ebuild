# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="ae amscls amsmath babel babel-english babelbib carlisle colortbl fancyhdr fix2col geometry graphics graphics-cfg hyperref latex latex-bin latex-fonts latexconfig ltxmisc mfnfss mptopdf natbib oberdiek pslatex psnfss pspicture tools url collection-latex
"
TEXLIVE_MODULE_DOC_CONTENTS="ae.doc amscls.doc amsmath.doc babel.doc babel-english.doc babelbib.doc carlisle.doc colortbl.doc fancyhdr.doc fix2col.doc geometry.doc graphics.doc graphics-cfg.doc hyperref.doc latex.doc latex-bin.doc latex-fonts.doc mfnfss.doc mptopdf.doc natbib.doc oberdiek.doc psnfss.doc pspicture.doc tools.doc url.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ae.source amscls.source amsmath.source babel.source babel-english.source carlisle.source colortbl.source fancyhdr.source fix2col.source geometry.source graphics.source hyperref.source latex.source mfnfss.source natbib.source oberdiek.source pslatex.source psnfss.source pspicture.source tools.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX fundamental packages"

LICENSE=" GPL-2 LPPL-1.3 LPPL-1.3c public-domain "
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2019
!!<dev-texlive/texlive-latex-2016
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/oberdiek/pdfatfi.pl
	texmf-dist/scripts/context/perl/mptopdf.pl
	"

src_prepare() {
	default
	rm -rf texmf-dist/scripts/context/stubs/mswin || die
}
