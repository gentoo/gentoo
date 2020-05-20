# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="automata bbcard blockdraw_mp bpolynomial cmarrows drv dviincl emp epsincl expressg exteps featpost feynmp-auto fiziko garrigues gmp hatching latexmp mcf2graph metago metaobj metaplot metapost metapost-colorbrewer metauml mfpic mfpic4ode mp3d mparrows mpattern mpcolornames mpgraphics mptrees piechartmp repere roex roundrect shapes slideshow splines suanpan textpath threeddice collection-metapost
"
TEXLIVE_MODULE_DOC_CONTENTS="automata.doc bbcard.doc blockdraw_mp.doc bpolynomial.doc cmarrows.doc drv.doc dviincl.doc emp.doc epsincl.doc expressg.doc exteps.doc featpost.doc feynmp-auto.doc fiziko.doc garrigues.doc gmp.doc hatching.doc latexmp.doc mcf2graph.doc metago.doc metaobj.doc metaplot.doc metapost.doc metapost-colorbrewer.doc metauml.doc mfpic.doc mfpic4ode.doc mp3d.doc mparrows.doc mpattern.doc mpcolornames.doc mpgraphics.doc mptrees.doc piechartmp.doc repere.doc roundrect.doc shapes.doc slideshow.doc splines.doc suanpan.doc textpath.doc threeddice.doc "
TEXLIVE_MODULE_SRC_CONTENTS="emp.source expressg.source feynmp-auto.source gmp.source mfpic.source mfpic4ode.source mpcolornames.source mpgraphics.source roex.source roundrect.source shapes.source splines.source "
inherit  texlive-module
DESCRIPTION="TeXLive MetaPost and Metafont packages"

LICENSE=" CC-BY-SA-4.0 GPL-1 GPL-2 GPL-3+ LGPL-2 LPPL-1.3 MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} "

# This small hack is needed in order to have a sane upgrade path:
# the new TeX Live 2009 metapost produces this file but it is not recorded in
# any package; when running fmtutil (like texmf-update does) this file will be
# created and cause collisions.

pkg_setup() {
	if [ -f "${ROOT}/${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem" ]; then
		einfo "Removing ${ROOT}/${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem"
		rm -f "${ROOT}/${EPREFIX}/var/lib/texmf/web2c/metapost/mplib-luatex.mem"
	fi
}
