# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="adjustbox asyfig autoarea bardiag bloques bodegraph bondgraph braids cachepic chemfig combinedgraphics circuitikz curve curve2e curves dcpic diagmac2 doc-pictex dottex  dratex drs duotenzor eepic  epspdfconversion esk fig4latex gincltex gnuplottex gradientframe grafcet here hvfloat knitting knittingpattern lapdf lpic mathspic miniplot modiagram numericplots pb-diagram petri-nets  pgf-blur pgf-soroban pgf-umlsd pgfgantt pgfkeyx pgfmolbio pgfopts pgfplots piano picinpar pict2e pictex pictex2 pinlabel pmgraph prerex productbox randbild randomwalk reotex roundbox rviewport schemabloc swimgraf texdraw tikz-cd tikz-3dplot tikz-dependency tikz-inet tikz-qtree tikz-timing tikzpagenodes tikzpfeile tqft tkz-base tkz-berge tkz-doc tkz-euclide tkz-fct tkz-graph tkz-kiviat tkz-linknodes tkz-orm tkz-tab tsemlines tufte-latex xypic collection-pictures
"
TEXLIVE_MODULE_DOC_CONTENTS="adjustbox.doc asyfig.doc autoarea.doc bardiag.doc bloques.doc bodegraph.doc bondgraph.doc braids.doc cachepic.doc chemfig.doc combinedgraphics.doc circuitikz.doc curve.doc curve2e.doc curves.doc dcpic.doc diagmac2.doc doc-pictex.doc dottex.doc dratex.doc drs.doc duotenzor.doc eepic.doc epspdfconversion.doc esk.doc fig4latex.doc gincltex.doc gnuplottex.doc gradientframe.doc grafcet.doc here.doc hvfloat.doc knitting.doc knittingpattern.doc lapdf.doc lpic.doc mathspic.doc miniplot.doc modiagram.doc numericplots.doc pb-diagram.doc petri-nets.doc pgf-blur.doc pgf-soroban.doc pgf-umlsd.doc pgfgantt.doc pgfkeyx.doc pgfmolbio.doc pgfopts.doc pgfplots.doc piano.doc picinpar.doc pict2e.doc pictex.doc pinlabel.doc pmgraph.doc prerex.doc productbox.doc randbild.doc randomwalk.doc reotex.doc roundbox.doc rviewport.doc schemabloc.doc swimgraf.doc texdraw.doc tikz-cd.doc tikz-3dplot.doc tikz-dependency.doc tikz-inet.doc tikz-qtree.doc tikz-timing.doc tikzpagenodes.doc tikzpfeile.doc tqft.doc tkz-base.doc tkz-berge.doc tkz-doc.doc tkz-euclide.doc tkz-fct.doc tkz-graph.doc tkz-kiviat.doc tkz-linknodes.doc tkz-orm.doc tkz-tab.doc tufte-latex.doc xypic.doc "
TEXLIVE_MODULE_SRC_CONTENTS="adjustbox.source asyfig.source braids.source combinedgraphics.source curve.source curve2e.source curves.source dottex.source esk.source gincltex.source gnuplottex.source gradientframe.source pgf-blur.source pgfgantt.source pgfmolbio.source pgfopts.source pgfplots.source pict2e.source productbox.source randbild.source randomwalk.source rviewport.source tikz-timing.source tikzpagenodes.source tikzpfeile.source tqft.source tufte-latex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Graphics packages and programs"

LICENSE="GPL-2 Apache-2.0 GPL-1 GPL-3 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
!<dev-texlive/texlive-latexextra-2009
!<dev-texlive/texlive-texinfo-2009
dev-tex/pgf
"
RDEPEND="${DEPEND}"
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/cachepic/cachepic.tlu texmf-dist/scripts/fig4latex/fig4latex texmf-dist/scripts/mathspic/mathspic.pl"
