# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="figflow fixpdfmag font-change fontch getoptk graphics-pln hyplain js-misc mkpattern newsletr pitex placeins-plain plipsum plnfss plstmary present resumemac texinfo timetable treetex varisize collection-plainextra
"
TEXLIVE_MODULE_DOC_CONTENTS="figflow.doc font-change.doc fontch.doc getoptk.doc graphics-pln.doc hyplain.doc js-misc.doc mkpattern.doc newsletr.doc pitex.doc plipsum.doc plnfss.doc plstmary.doc present.doc resumemac.doc treetex.doc varisize.doc "
TEXLIVE_MODULE_SRC_CONTENTS="graphics-pln.source "
inherit  texlive-module
DESCRIPTION="TeXLive Plain TeX packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!<dev-texlive/texlive-langvietnamese-2009
!dev-texlive/texlive-texinfo
"
RDEPEND="${DEPEND} "
