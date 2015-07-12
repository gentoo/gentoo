# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-metapost/texlive-metapost-2014.ebuild,v 1.3 2015/07/12 18:09:08 zlogene Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="automata bbcard blockdraw_mp bpolynomial cmarrows drv dviincl emp epsincl expressg exteps featpost feynmp-auto garrigues gmp hatching latexmp metago metaobj metaplot metapost metauml mfpic mfpic4ode mp3d mpcolornames mpattern mpgraphics piechartmp repere roex slideshow splines suanpan textpath threeddice collection-metapost
"
TEXLIVE_MODULE_DOC_CONTENTS="automata.doc bbcard.doc blockdraw_mp.doc bpolynomial.doc cmarrows.doc drv.doc dviincl.doc emp.doc epsincl.doc expressg.doc exteps.doc featpost.doc feynmp-auto.doc garrigues.doc gmp.doc hatching.doc latexmp.doc metago.doc metaobj.doc metaplot.doc metapost.doc metauml.doc mfpic.doc mfpic4ode.doc mp3d.doc mpcolornames.doc mpattern.doc mpgraphics.doc piechartmp.doc repere.doc slideshow.doc splines.doc suanpan.doc textpath.doc threeddice.doc "
TEXLIVE_MODULE_SRC_CONTENTS="emp.source expressg.source feynmp-auto.source gmp.source mfpic.source mfpic4ode.source mpcolornames.source mpgraphics.source roex.source splines.source "
inherit  texlive-module
DESCRIPTION="TeXLive MetaPost and Metafont packages"

LICENSE=" GPL-1 GPL-2 LGPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
"
RDEPEND="${DEPEND} "

# This small hack is needed in order to have a sane upgrade path:
# the new TeX Live 2009 metapost produces this file but it is not recorded in
# any package; when running fmtutil (like texmf-update does) this file will be
# created and cause collisions.

pkg_setup() {
	if [ -f "${ROOT%/}${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem" ]; then
		einfo "Removing ${ROOT%/}${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem"
		rm -f "${ROOT%/}${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem"
	fi
}
