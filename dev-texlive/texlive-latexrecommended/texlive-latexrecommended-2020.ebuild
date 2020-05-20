# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="anysize attachfile2  booktabs breqn caption cite cmap crop ctable eso-pic euenc euler etoolbox extsizes fancybox fancyref fancyvrb filehook float fontspec footnotehyper fp grffile hologo index infwarerr jknapltx koma-script latexbug l3experimental l3packages lineno listings lwarp mathspec mathtools mdwtools memoir metalogo microtype ms newfloat ntgclass parskip pdflscape pdfpages pdftexcmds polyglossia psfrag ragged2e rcs sansmath section seminar sepnum setspace subfig textcase thumbpdf translator typehtml ucharcat underscore unicode-math xcolor xkeyval xltxtra xunicode collection-latexrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="anysize.doc attachfile2.doc booktabs.doc breqn.doc caption.doc cite.doc cmap.doc crop.doc ctable.doc eso-pic.doc euenc.doc euler.doc etoolbox.doc extsizes.doc fancybox.doc fancyref.doc fancyvrb.doc filehook.doc float.doc fontspec.doc footnotehyper.doc fp.doc grffile.doc hologo.doc index.doc infwarerr.doc jknapltx.doc latexbug.doc l3experimental.doc l3packages.doc lineno.doc listings.doc lwarp.doc mathspec.doc mathtools.doc mdwtools.doc memoir.doc metalogo.doc microtype.doc ms.doc newfloat.doc ntgclass.doc parskip.doc pdflscape.doc pdfpages.doc pdftexcmds.doc polyglossia.doc psfrag.doc ragged2e.doc rcs.doc sansmath.doc section.doc seminar.doc sepnum.doc setspace.doc subfig.doc textcase.doc thumbpdf.doc translator.doc typehtml.doc ucharcat.doc underscore.doc unicode-math.doc xcolor.doc xkeyval.doc xltxtra.doc xunicode.doc "
TEXLIVE_MODULE_SRC_CONTENTS="attachfile2.source booktabs.source breqn.source caption.source crop.source ctable.source eso-pic.source euenc.source euler.source fancyref.source filehook.source float.source fontspec.source footnotehyper.source grffile.source hologo.source index.source infwarerr.source latexbug.source l3experimental.source l3packages.source lineno.source listings.source lwarp.source mathtools.source mdwtools.source memoir.source metalogo.source microtype.source ms.source newfloat.source ntgclass.source parskip.source pdflscape.source pdfpages.source pdftexcmds.source polyglossia.source psfrag.source ragged2e.source rcs.source subfig.source textcase.source typehtml.source ucharcat.source unicode-math.source xcolor.source xkeyval.source xltxtra.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX recommended packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2020
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/thumbpdf/thumbpdf.pl
	texmf-dist/scripts/lwarp/lwarpmk.lua"
