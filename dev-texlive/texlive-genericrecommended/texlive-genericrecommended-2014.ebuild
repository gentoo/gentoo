# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-genericrecommended/texlive-genericrecommended-2014.ebuild,v 1.2 2015/07/12 15:45:16 ago Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="epsf fontname genmisc kastrup multido path tex-ps ulem collection-genericrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="epsf.doc fontname.doc kastrup.doc multido.doc path.doc tex-ps.doc ulem.doc "
TEXLIVE_MODULE_SRC_CONTENTS="kastrup.source multido.source "
inherit  texlive-module
DESCRIPTION="TeXLive Generic recommended packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
!=dev-texlive/texlive-basic-2007*
!<dev-texlive/texlive-texinfo-2009
!<dev-texlive/texlive-latexextra-2010
"
RDEPEND="${DEPEND} "
