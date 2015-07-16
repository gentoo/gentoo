# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-science/texlive-science-2015.ebuild,v 1.1 2015/07/16 09:28:18 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="SIstyle SIunits alg algorithm2e algorithmicx algorithms biocon bohr bpchem bytefield chemarrow chemcompounds chemcono chemexec chemformula chemgreek chemmacros chemnum chemschemex chemstyle clrscode clrscode3e complexity computational-complexity cryptocode digiconfigs drawstack dyntree eltex endiagram engtlc fouridx functan galois gastex gene-logic ghsystem gu hep hepnames hepparticles hepthesis hepunits karnaugh karnaughmap matlab-prettifier mhchem miller mychemistry nuc objectz physics pseudocode pygmentex sasnrdisplay sciposter sclang-prettifier sfg siunitx steinmetz struktex substances t-angles textopo ulqda unitsdef xymtex youngtab collection-science
"
TEXLIVE_MODULE_DOC_CONTENTS="SIstyle.doc SIunits.doc alg.doc algorithm2e.doc algorithmicx.doc algorithms.doc biocon.doc bohr.doc bpchem.doc bytefield.doc chemarrow.doc chemcompounds.doc chemcono.doc chemexec.doc chemformula.doc chemgreek.doc chemmacros.doc chemnum.doc chemschemex.doc chemstyle.doc clrscode.doc clrscode3e.doc complexity.doc computational-complexity.doc cryptocode.doc digiconfigs.doc drawstack.doc dyntree.doc eltex.doc endiagram.doc engtlc.doc fouridx.doc functan.doc galois.doc gastex.doc gene-logic.doc ghsystem.doc gu.doc hep.doc hepnames.doc hepparticles.doc hepthesis.doc hepunits.doc karnaugh.doc karnaughmap.doc matlab-prettifier.doc mhchem.doc miller.doc mychemistry.doc nuc.doc objectz.doc physics.doc pseudocode.doc pygmentex.doc sasnrdisplay.doc sciposter.doc sclang-prettifier.doc sfg.doc siunitx.doc steinmetz.doc struktex.doc substances.doc t-angles.doc textopo.doc ulqda.doc unitsdef.doc xymtex.doc youngtab.doc "
TEXLIVE_MODULE_SRC_CONTENTS="SIstyle.source SIunits.source alg.source algorithms.source bpchem.source bytefield.source chemarrow.source chemcompounds.source chemschemex.source chemstyle.source computational-complexity.source dyntree.source fouridx.source functan.source galois.source karnaughmap.source matlab-prettifier.source miller.source objectz.source sclang-prettifier.source siunitx.source steinmetz.source struktex.source textopo.source ulqda.source unitsdef.source xymtex.source youngtab.source "
inherit  texlive-module
DESCRIPTION="TeXLive Natural and computer sciences"

LICENSE=" GPL-1 GPL-2 LGPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2015
!dev-tex/SIunits
"
RDEPEND="${DEPEND} dev-texlive/texlive-pstricks
"
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/ulqda/ulqda.pl texmf-dist/scripts/pygmentex/pygmentex.py"
