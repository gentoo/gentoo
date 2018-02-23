# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="avantgar bookman charter cm-super cmextra courier ec euro euro-ce eurosym fpl helvetic lm lm-math marvosym mathpazo manfnt-font mflogo-font ncntrsbk palatino pxfonts rsfs symbol tex-gyre tex-gyre-math times tipa txfonts utopia wasy wasy2-ps wasysym zapfchan zapfding collection-fontsrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="charter.doc cm-super.doc ec.doc euro.doc euro-ce.doc eurosym.doc fpl.doc lm.doc lm-math.doc marvosym.doc mathpazo.doc mflogo-font.doc pxfonts.doc rsfs.doc tex-gyre.doc tex-gyre-math.doc tipa.doc txfonts.doc utopia.doc wasy.doc wasy2-ps.doc wasysym.doc "
TEXLIVE_MODULE_SRC_CONTENTS="euro.source fpl.source lm.source marvosym.source mathpazo.source tex-gyre-math.source wasysym.source "
inherit  texlive-module
DESCRIPTION="TeXLive Recommended fonts"

LICENSE=" BSD GPL-1 GPL-2 LPPL-1.3 OFL public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2017
!=dev-texlive/texlive-basic-2007*
!<dev-texlive/texlive-fontsextra-2010
!<dev-texlive/texlive-latexrecommended-2014
"
RDEPEND="${DEPEND} "
