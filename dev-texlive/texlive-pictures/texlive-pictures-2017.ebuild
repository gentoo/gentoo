# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="aobs-tikz askmaps asyfig asypictureb autoarea bardiag beamerswitch binarytree blochsphere bloques blox bodegraph bondgraph bondgraphs braids bxeepic cachepic callouts celtic chemfig combinedgraphics circuitikz curve curve2e curves dcpic diagmac2 doc-pictex dottex  dratex drs duotenzor ecgdraw eepic ellipse  epspdfconversion esk fast-diagram fig4latex fitbox flowchart forest genealogytree getmap gincltex gnuplottex gradientframe grafcet graphviz gtrlib-largetrees harveyballs here hf-tikz hobby hvfloat knitting knittingpattern ladder lapdf latex-make lpic lroundrect luamesh makeshape mathspic miniplot mkpic modiagram neuralnetwork numericplots pb-diagram petri-nets  pgf-blur pgf-soroban pgf-spectra pgf-umlcd pgf-umlsd pgfgantt pgfkeyx pgfmolbio pgfopts pgfornament pgfplots picinpar pict2e pictex pictex2 pinlabel pmgraph prerex productbox pxpgfmark qcircuit qrcode randbild randomwalk reotex rviewport sa-tikz schemabloc scsnowman scratch setdeck signchart smartdiagram spath3 swimgraf table-fct texdraw ticollege tipfr tikz-3dplot tikz-bayesnet tikz-cd tikz-dependency tikz-dimline tikz-feynman tikz-inet tikz-kalender tikz-opm tikz-optics tikz-page tikz-palattice tikz-qtree tikz-timing tikzinclude tikzmark tikzorbital tikzpagenodes tikzpfeile tikzpeople tikzposter tikzscale tikzsymbols timing-diagrams tqft tkz-base tkz-berge tkz-doc tkz-euclide tkz-fct tkz-graph tkz-kiviat tkz-linknodes tkz-orm tkz-tab tsemlines tufte-latex venndiagram visualpstricks xpicture xypic collection-pictures
"
TEXLIVE_MODULE_DOC_CONTENTS="aobs-tikz.doc askmaps.doc asyfig.doc asypictureb.doc autoarea.doc bardiag.doc beamerswitch.doc binarytree.doc blochsphere.doc bloques.doc blox.doc bodegraph.doc bondgraph.doc bondgraphs.doc braids.doc bxeepic.doc cachepic.doc callouts.doc celtic.doc chemfig.doc combinedgraphics.doc circuitikz.doc curve.doc curve2e.doc curves.doc dcpic.doc diagmac2.doc doc-pictex.doc dottex.doc dratex.doc drs.doc duotenzor.doc ecgdraw.doc eepic.doc ellipse.doc epspdfconversion.doc esk.doc fast-diagram.doc fig4latex.doc fitbox.doc flowchart.doc forest.doc genealogytree.doc getmap.doc gincltex.doc gnuplottex.doc gradientframe.doc grafcet.doc graphviz.doc gtrlib-largetrees.doc harveyballs.doc here.doc hf-tikz.doc hobby.doc hvfloat.doc knitting.doc knittingpattern.doc ladder.doc lapdf.doc latex-make.doc lpic.doc lroundrect.doc luamesh.doc makeshape.doc mathspic.doc miniplot.doc mkpic.doc modiagram.doc neuralnetwork.doc numericplots.doc pb-diagram.doc petri-nets.doc pgf-blur.doc pgf-soroban.doc pgf-spectra.doc pgf-umlcd.doc pgf-umlsd.doc pgfgantt.doc pgfkeyx.doc pgfmolbio.doc pgfopts.doc pgfornament.doc pgfplots.doc picinpar.doc pict2e.doc pictex.doc pinlabel.doc pmgraph.doc prerex.doc productbox.doc pxpgfmark.doc qcircuit.doc qrcode.doc randbild.doc randomwalk.doc reotex.doc rviewport.doc sa-tikz.doc schemabloc.doc scsnowman.doc scratch.doc setdeck.doc signchart.doc smartdiagram.doc spath3.doc swimgraf.doc table-fct.doc texdraw.doc ticollege.doc tipfr.doc tikz-3dplot.doc tikz-bayesnet.doc tikz-cd.doc tikz-dependency.doc tikz-dimline.doc tikz-feynman.doc tikz-inet.doc tikz-kalender.doc tikz-opm.doc tikz-optics.doc tikz-page.doc tikz-palattice.doc tikz-qtree.doc tikz-timing.doc tikzinclude.doc tikzmark.doc tikzorbital.doc tikzpagenodes.doc tikzpfeile.doc tikzpeople.doc tikzposter.doc tikzscale.doc tikzsymbols.doc timing-diagrams.doc tqft.doc tkz-base.doc tkz-berge.doc tkz-doc.doc tkz-euclide.doc tkz-fct.doc tkz-graph.doc tkz-kiviat.doc tkz-linknodes.doc tkz-orm.doc tkz-tab.doc tufte-latex.doc venndiagram.doc visualpstricks.doc xpicture.doc xypic.doc "
TEXLIVE_MODULE_SRC_CONTENTS="aobs-tikz.source asyfig.source asypictureb.source beamerswitch.source binarytree.source blochsphere.source blox.source bondgraphs.source braids.source celtic.source combinedgraphics.source curve.source curve2e.source curves.source dottex.source ecgdraw.source ellipse.source esk.source fitbox.source flowchart.source forest.source gincltex.source gnuplottex.source gradientframe.source graphviz.source gtrlib-largetrees.source hf-tikz.source hobby.source latex-make.source lroundrect.source makeshape.source pgf-blur.source pgfgantt.source pgfmolbio.source pgfopts.source pgfplots.source pict2e.source productbox.source qrcode.source randbild.source randomwalk.source rviewport.source signchart.source smartdiagram.source spath3.source tikz-page.source tikz-timing.source tikzinclude.source tikzmark.source tikzpagenodes.source tikzpfeile.source tikzposter.source tikzscale.source tikzsymbols.source tqft.source venndiagram.source xpicture.source "
inherit  texlive-module
DESCRIPTION="TeXLive Graphics, pictures, diagrams"

LICENSE=" Apache-2.0 BSD-2 GPL-1 GPL-2 GPL-3 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2017
!<dev-texlive/texlive-latexextra-2009
!<dev-texlive/texlive-texinfo-2009
>=dev-tex/pgf-3.0.1
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/cachepic/cachepic.tlu
	texmf-dist/scripts/fig4latex/fig4latex
	texmf-dist/scripts/mathspic/mathspic.pl
	texmf-dist/scripts/mkpic/mkpic
	texmf-dist/scripts/getmap/getmapdl.lua
	texmf-dist/scripts/petri-nets/pn2pdf
"
