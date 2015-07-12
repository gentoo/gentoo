# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-formatsextra/texlive-formatsextra-2014.ebuild,v 1.4 2015/07/12 15:45:04 ago Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="edmac eplain lollipop mltex psizzl startex texsis collection-formatsextra
"
TEXLIVE_MODULE_DOC_CONTENTS="edmac.doc eplain.doc lollipop.doc mltex.doc psizzl.doc startex.doc texsis.doc "
TEXLIVE_MODULE_SRC_CONTENTS="edmac.source eplain.source psizzl.source startex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Additional formats"

LICENSE=" GPL-2 GPL-3 LPPL-1.3 public-domain TeX "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
>=dev-texlive/texlive-xetex-2014
>=dev-texlive/texlive-latex-2008
"
RDEPEND="${DEPEND} "
