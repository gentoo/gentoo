# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langcyrillic/texlive-langcyrillic-2015.ebuild,v 1.1 2015/07/16 09:17:47 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-bulgarian babel-russian babel-serbian babel-serbianc babel-ukraineb cmcyr cyrillic cyrillic-bin cyrplain disser eskd eskdx gost hyphen-bulgarian hyphen-mongolian hyphen-russian hyphen-serbian hyphen-ukrainian lcyw lh lhcyr lshort-bulgarian lshort-mongol lshort-russian lshort-ukr mongolian-babel montex mpman-ru pst-eucl-translation-bg ruhyphen russ serbian-apostrophe serbian-date-lat serbian-def-cyr serbian-lig t2 texlive-ru texlive-sr ukrhyph collection-langcyrillic
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-bulgarian.doc babel-russian.doc babel-serbian.doc babel-serbianc.doc babel-ukraineb.doc cmcyr.doc cyrillic.doc cyrillic-bin.doc disser.doc eskd.doc eskdx.doc gost.doc lcyw.doc lh.doc lshort-bulgarian.doc lshort-mongol.doc lshort-russian.doc lshort-ukr.doc mongolian-babel.doc montex.doc mpman-ru.doc pst-eucl-translation-bg.doc russ.doc serbian-apostrophe.doc serbian-date-lat.doc serbian-def-cyr.doc serbian-lig.doc t2.doc texlive-ru.doc texlive-sr.doc ukrhyph.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-bulgarian.source babel-russian.source babel-serbian.source babel-serbianc.source babel-ukraineb.source cyrillic.source disser.source eskd.source gost.source lcyw.source lh.source lhcyr.source mongolian-babel.source ruhyphen.source "
inherit  texlive-module
DESCRIPTION="TeXLive Cyrillic"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2015
>=dev-texlive/texlive-latex-2015
!dev-texlive/texlive-documentation-ukrainian
!dev-texlive/texlive-documentation-bulgarian
!dev-texlive/texlive-documentation-russian
!dev-texlive/texlive-documentation-mongolian
!dev-texlive/texlive-langmongolian
!<dev-texlive/texlive-langother-2013
!dev-texlive/texlive-documentation-serbian
!<app-text/texlive-core-2013
!<dev-texlive/texlive-latexextra-2013
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/texlive/rubibtex.sh
	texmf-dist/scripts/texlive/rumakeindex.sh
	"
