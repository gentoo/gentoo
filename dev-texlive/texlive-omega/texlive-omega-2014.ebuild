# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="aleph antomega lambda mxedruli omega omegaware otibet collection-omega
"
TEXLIVE_MODULE_DOC_CONTENTS="aleph.doc antomega.doc mxedruli.doc omega.doc omegaware.doc otibet.doc "
TEXLIVE_MODULE_SRC_CONTENTS="antomega.source otibet.source "
inherit  texlive-module
DESCRIPTION="TeXLive Omega packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
>=dev-texlive/texlive-latex-2014
>=dev-texlive/texlive-latex-2008
!<dev-texlive/texlive-fontsextra-2009
!dev-texlive/texlive-langtibetan
!<dev-texlive/texlive-basic-2014
"
RDEPEND="${DEPEND} "
