# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="anysize  booktabs caption cite cmap crop ctable ec eso-pic euler extsizes fancybox fancyref fancyvrb float fontspec fp index jknapltx koma-script l3kernel l3packages l3experimental listings mdwtools memoir metalogo mh microtype ms ntgclass parskip pdfpages powerdot psfrag rcs rotating sansmath section seminar sepnum setspace subfig textcase thumbpdf typehtml underscore url  xkeyval collection-latexrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="anysize.doc booktabs.doc caption.doc cite.doc cmap.doc crop.doc ctable.doc ec.doc eso-pic.doc euler.doc extsizes.doc fancybox.doc fancyref.doc fancyvrb.doc float.doc fontspec.doc fp.doc index.doc jknapltx.doc l3kernel.doc l3packages.doc l3experimental.doc listings.doc mdwtools.doc memoir.doc metalogo.doc mh.doc microtype.doc ms.doc ntgclass.doc parskip.doc pdfpages.doc powerdot.doc psfrag.doc rcs.doc rotating.doc sansmath.doc section.doc seminar.doc sepnum.doc setspace.doc subfig.doc textcase.doc thumbpdf.doc typehtml.doc underscore.doc url.doc xkeyval.doc "
TEXLIVE_MODULE_SRC_CONTENTS="booktabs.source caption.source crop.source ctable.source eso-pic.source euler.source fancyref.source fancyvrb.source float.source fontspec.source index.source l3kernel.source l3packages.source l3experimental.source listings.source mdwtools.source memoir.source metalogo.source mh.source microtype.source ms.source ntgclass.source pdfpages.source psfrag.source rcs.source rotating.source subfig.source textcase.source typehtml.source xkeyval.source "
inherit  texlive-module
DESCRIPTION="TeXLive LaTeX recommended packages"

LICENSE="GPL-2 GPL-1 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2012
>=dev-texlive/texlive-latex-2012
>=dev-texlive/texlive-latex-2012
!dev-tex/xkeyval
!dev-tex/memoir
!dev-tex/listings
!dev-tex/mh
!<dev-texlive/texlive-latexextra-2011
!=app-text/texlive-core-2007*
!<dev-texlive/texlive-xetex-2011
!dev-texlive/texlive-latex3
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/thumbpdf/thumbpdf.pl"
PATCHES=( "${FILESDIR}/thumbpdf_invocation.patch" )
