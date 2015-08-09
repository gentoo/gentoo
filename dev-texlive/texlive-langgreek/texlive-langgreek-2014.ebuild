# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-greek betababel bgreek cbfonts cbfonts-fd gfsbaskerville gfsporson greek-fontenc greek-inputenc greekdates greektex hyphen-greek hyphen-ancientgreek ibycus-babel ibygrk kerkis levy lgreek mkgrkindex teubner xgreek yannisgr collection-langgreek
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-greek.doc betababel.doc bgreek.doc cbfonts.doc cbfonts-fd.doc gfsbaskerville.doc gfsporson.doc greek-fontenc.doc greek-inputenc.doc greekdates.doc greektex.doc hyphen-greek.doc ibycus-babel.doc ibygrk.doc kerkis.doc levy.doc lgreek.doc mkgrkindex.doc teubner.doc xgreek.doc yannisgr.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-greek.source cbfonts-fd.source greekdates.source ibycus-babel.source teubner.source xgreek.source "
inherit  texlive-module
DESCRIPTION="TeXLive Greek"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/mkgrkindex/mkgrkindex"
