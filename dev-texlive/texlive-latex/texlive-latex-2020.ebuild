# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="ae amscls amsmath atbegshi atveryend auxhook babel babel-english babelbib bigintcalc bitset bookmark carlisle colortbl epstopdf-pkg etexcmds fancyhdr fix2col geometry gettitlestring graphics graphics-cfg grfext hycolor hyperref intcalc kvdefinekeys kvoptions kvsetkeys l3backend l3kernel latex latex-bin latex-fonts latexconfig letltxmacro ltxcmds ltxmisc mfnfss mptopdf natbib oberdiek pdfescape pslatex psnfss pspicture refcount rerunfilecheck stringenc tools uniquecounter url collection-latex
"
TEXLIVE_MODULE_DOC_CONTENTS="ae.doc amscls.doc amsmath.doc atbegshi.doc atveryend.doc auxhook.doc babel.doc babel-english.doc babelbib.doc bigintcalc.doc bitset.doc bookmark.doc carlisle.doc colortbl.doc epstopdf-pkg.doc etexcmds.doc fancyhdr.doc fix2col.doc geometry.doc gettitlestring.doc graphics.doc graphics-cfg.doc grfext.doc hycolor.doc hyperref.doc intcalc.doc kvdefinekeys.doc kvoptions.doc kvsetkeys.doc l3backend.doc l3kernel.doc latex.doc latex-bin.doc latex-fonts.doc letltxmacro.doc ltxcmds.doc mfnfss.doc mptopdf.doc natbib.doc oberdiek.doc pdfescape.doc psnfss.doc pspicture.doc refcount.doc rerunfilecheck.doc stringenc.doc tools.doc uniquecounter.doc url.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ae.source amscls.source amsmath.source atbegshi.source atveryend.source auxhook.source babel.source babel-english.source bigintcalc.source bitset.source bookmark.source carlisle.source colortbl.source epstopdf-pkg.source etexcmds.source fancyhdr.source fix2col.source geometry.source gettitlestring.source graphics.source grfext.source hycolor.source hyperref.source intcalc.source kvdefinekeys.source kvoptions.source kvsetkeys.source l3backend.source l3kernel.source latex.source letltxmacro.source ltxcmds.source mfnfss.source natbib.source oberdiek.source pdfescape.source pslatex.source psnfss.source pspicture.source refcount.source rerunfilecheck.source stringenc.source tools.source uniquecounter.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX fundamental packages"

LICENSE=" GPL-2 LPPL-1.3 LPPL-1.3c public-domain "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
!~dev-texlive/texlive-latexrecommended-2019
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	rm -rf texmf-dist/scripts/context/stubs/mswin || die
}
TEXLIVE_MODUE_BINSCRIPTS="texmf-dist/scripts/context/perl/mptopdf.pl"
