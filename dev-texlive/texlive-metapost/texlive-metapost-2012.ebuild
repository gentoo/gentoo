# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="automata bbcard blockdraw_mp bpolynomial cmarrows drv dviincl emp epsincl expressg exteps featpost garrigues gmp hatching latexmp metago metaobj metaplot metapost metauml mfpic mfpic4ode mp3d mpcolornames mpgraphics mpattern piechartmp roex slideshow splines suanpan textpath threeddice collection-metapost
"
TEXLIVE_MODULE_DOC_CONTENTS="automata.doc bbcard.doc blockdraw_mp.doc bpolynomial.doc cmarrows.doc drv.doc dviincl.doc emp.doc epsincl.doc expressg.doc exteps.doc featpost.doc garrigues.doc gmp.doc hatching.doc latexmp.doc metago.doc metaobj.doc metaplot.doc metapost.doc metauml.doc mfpic.doc mfpic4ode.doc mp3d.doc mpcolornames.doc mpgraphics.doc mpattern.doc piechartmp.doc slideshow.doc splines.doc suanpan.doc textpath.doc threeddice.doc "
TEXLIVE_MODULE_SRC_CONTENTS="emp.source expressg.source gmp.source mfpic.source mfpic4ode.source mpcolornames.source mpgraphics.source roex.source splines.source "
inherit  texlive-module
DESCRIPTION="TeXLive MetaPost (and Metafont) drawing packages"

LICENSE="GPL-2 GPL-1 LGPL-2 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
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
