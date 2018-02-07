# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="adobemapping c90 cjk-gs-integrate cjkpunct dnp garuda-c90 norasi-c90 pxtatescale xcjk2uni zxjafont collection-langcjk
"
TEXLIVE_MODULE_DOC_CONTENTS="c90.doc cjk-gs-integrate.doc cjkpunct.doc pxtatescale.doc xcjk2uni.doc zxjafont.doc "
TEXLIVE_MODULE_SRC_CONTENTS="c90.source cjkpunct.source garuda-c90.source norasi-c90.source xcjk2uni.source "
inherit  texlive-module
DESCRIPTION="TeXLive Chinese/Japanese/Korean (base)"

LICENSE=" BSD GPL-2 GPL-3 LPPL-1.3 MIT TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2017
>=app-text/texlive-core-2010[cjk]
>=dev-texlive/texlive-latex-2011
!!<dev-texlive/texlive-langcjk-2012
!dev-texlive/texlive-documentation-chinese
!dev-texlive/texlive-documentation-korean
!dev-texlive/texlive-documentation-japanese
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/cjk-gs-integrate/cjk-gs-integrate.pl"
