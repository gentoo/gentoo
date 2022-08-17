# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="ae amscls amsmath atbegshi atveryend auxhook babel babel-english babelbib bigintcalc bitset bookmark carlisle colortbl epstopdf-pkg etexcmds fancyhdr firstaid fix2col geometry gettitlestring graphics graphics-cfg grfext hopatch hycolor hyperref intcalc kvdefinekeys kvoptions kvsetkeys l3backend l3kernel l3packages latex latex-bin latex-fonts latexconfig letltxmacro ltxcmds ltxmisc mfnfss mptopdf natbib oberdiek pagesel pdfescape pslatex psnfss pspicture refcount rerunfilecheck stringenc tools uniquecounter url collection-latex
"
TEXLIVE_MODULE_DOC_CONTENTS="ae.doc amscls.doc amsmath.doc atbegshi.doc atveryend.doc auxhook.doc babel.doc babel-english.doc babelbib.doc bigintcalc.doc bitset.doc bookmark.doc carlisle.doc colortbl.doc epstopdf-pkg.doc etexcmds.doc fancyhdr.doc firstaid.doc fix2col.doc geometry.doc gettitlestring.doc graphics.doc graphics-cfg.doc grfext.doc hopatch.doc hycolor.doc hyperref.doc intcalc.doc kvdefinekeys.doc kvoptions.doc kvsetkeys.doc l3backend.doc l3kernel.doc l3packages.doc latex.doc latex-bin.doc latex-fonts.doc letltxmacro.doc ltxcmds.doc mfnfss.doc mptopdf.doc natbib.doc oberdiek.doc pagesel.doc pdfescape.doc psnfss.doc pspicture.doc refcount.doc rerunfilecheck.doc stringenc.doc tools.doc uniquecounter.doc url.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ae.source amscls.source amsmath.source atbegshi.source atveryend.source auxhook.source babel.source babel-english.source bigintcalc.source bitset.source bookmark.source carlisle.source colortbl.source epstopdf-pkg.source etexcmds.source fancyhdr.source firstaid.source fix2col.source geometry.source gettitlestring.source graphics.source grfext.source hopatch.source hycolor.source hyperref.source intcalc.source kvdefinekeys.source kvoptions.source kvsetkeys.source l3backend.source l3kernel.source l3packages.source latex.source letltxmacro.source ltxcmds.source mfnfss.source natbib.source oberdiek.source pagesel.source pdfescape.source pslatex.source psnfss.source pspicture.source refcount.source rerunfilecheck.source stringenc.source tools.source uniquecounter.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX fundamental packages"

LICENSE=" GPL-2 LPPL-1.3 LPPL-1.3c public-domain "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021
!~dev-texlive/texlive-latexrecommended-2020
"

RDEPEND="${DEPEND} "
src_prepare() {
	default
	rm -rf texmf-dist/scripts/context/stubs/mswin || die
}
