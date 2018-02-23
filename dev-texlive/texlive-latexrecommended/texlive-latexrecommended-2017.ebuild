# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="anysize  booktabs breqn caption cite cmap crop ctable eso-pic euenc euler extsizes fancybox fancyref fancyvrb filehook float fontspec fp index jknapltx koma-script latexbug l3experimental l3kernel l3packages lineno listings lwarp mathspec mathtools mdwtools memoir metalogo microtype ms ntgclass parskip pdfpages polyglossia powerdot psfrag rcs sansmath section seminar sepnum setspace subfig textcase thumbpdf typehtml underscore unicode-math  xkeyval xltxtra xunicode collection-latexrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="anysize.doc booktabs.doc breqn.doc caption.doc cite.doc cmap.doc crop.doc ctable.doc eso-pic.doc euenc.doc euler.doc extsizes.doc fancybox.doc fancyref.doc fancyvrb.doc filehook.doc float.doc fontspec.doc fp.doc index.doc jknapltx.doc latexbug.doc l3experimental.doc l3kernel.doc l3packages.doc lineno.doc listings.doc lwarp.doc mathspec.doc mathtools.doc mdwtools.doc memoir.doc metalogo.doc microtype.doc ms.doc ntgclass.doc parskip.doc pdfpages.doc polyglossia.doc powerdot.doc psfrag.doc rcs.doc sansmath.doc section.doc seminar.doc sepnum.doc setspace.doc subfig.doc textcase.doc thumbpdf.doc typehtml.doc underscore.doc unicode-math.doc xkeyval.doc xltxtra.doc xunicode.doc "
TEXLIVE_MODULE_SRC_CONTENTS="booktabs.source breqn.source caption.source crop.source ctable.source eso-pic.source euenc.source euler.source fancyref.source fancyvrb.source filehook.source float.source fontspec.source index.source latexbug.source l3experimental.source l3kernel.source l3packages.source lineno.source listings.source lwarp.source mathtools.source mdwtools.source memoir.source metalogo.source microtype.source ms.source ntgclass.source pdfpages.source polyglossia.source powerdot.source psfrag.source rcs.source subfig.source textcase.source typehtml.source unicode-math.source xkeyval.source xltxtra.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX recommended packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2017
!dev-tex/xkeyval
!dev-tex/memoir
!dev-tex/listings
!<dev-texlive/texlive-latexextra-2017
!=app-text/texlive-core-2007*
!<dev-texlive/texlive-xetex-2016
!dev-texlive/texlive-latex3
!<dev-texlive/texlive-humanities-2014
!dev-texlive/texlive-mathextra
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/thumbpdf/thumbpdf.pl texmf-dist/scripts/lwarp/lwarpmk.lua"
PATCHES=( "${FILESDIR}/thumbpdf_invocation.patch" )
