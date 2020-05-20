# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="edmac eplain  lollipop mltex psizzl startex texsis  xmltexconfig aleph antomega lambda mxedruli omega omegaware otibet collection-formatsextra
"
TEXLIVE_MODULE_DOC_CONTENTS="edmac.doc eplain.doc lollipop.doc mltex.doc psizzl.doc startex.doc texsis.doc aleph.doc antomega.doc mxedruli.doc omega.doc omegaware.doc otibet.doc "
TEXLIVE_MODULE_SRC_CONTENTS="edmac.source eplain.source psizzl.source startex.source antomega.source otibet.source "
inherit  texlive-module
DESCRIPTION="TeXLive Additional formats"

LICENSE=" GPL-1 GPL-2 GPL-3 LPPL-1.3 public-domain TeX "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
>=dev-texlive/texlive-latex-2020
dev-texlive/texlive-xetex
"
RDEPEND="${DEPEND} "
