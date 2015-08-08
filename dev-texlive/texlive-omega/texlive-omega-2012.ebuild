# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="antomega lambda mxedruli omega aleph omegaware collection-omega
"
TEXLIVE_MODULE_DOC_CONTENTS="antomega.doc mxedruli.doc omega.doc aleph.doc omegaware.doc "
TEXLIVE_MODULE_SRC_CONTENTS="antomega.source "
inherit  texlive-module
DESCRIPTION="TeXLive Omega packages"

LICENSE="GPL-2 GPL-1 LPPL-1.3 TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
>=dev-texlive/texlive-latex-2012
>=dev-texlive/texlive-latex-2008
!<dev-texlive/texlive-fontsextra-2009
"
RDEPEND="${DEPEND} "
