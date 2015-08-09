# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="bangtex bengali burmese devnag ebong hyphen-indic hyphen-sanskrit sanskrit sanskrit-t1 velthuis wnri wnri-latex xetex-devanagari collection-langindic
"
TEXLIVE_MODULE_DOC_CONTENTS="bangtex.doc bengali.doc burmese.doc ebong.doc sanskrit.doc sanskrit-t1.doc velthuis.doc wnri.doc wnri-latex.doc xetex-devanagari.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bengali.source burmese.source sanskrit.source wnri-latex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Indic scripts"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2015
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/ebong/ebong.py"
