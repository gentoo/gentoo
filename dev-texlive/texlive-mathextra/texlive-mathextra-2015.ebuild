# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="12many amstex backnaur begriff binomexp boldtensors bosisio bropd calculation ccfonts commath concmath concrete conteq ebproof eqnarray extarrows extpfeil faktor grundgesetze interval ionumbers isomath logicproof lpform lplfitch mathcomp mattens mhequ multiobjective natded nath ot-tableau oubraces perfectcut prftree proba rec-thy ribbonproofs rmathbr sesamanuel shuffle skmath statex statex2 stmaryrd subsupscripts susy syllogism sympytexpackage synproof tablor tensor tex-ewd thmbox turnstile unicode-math venn yhmath ytableau collection-mathextra
"
TEXLIVE_MODULE_DOC_CONTENTS="12many.doc amstex.doc backnaur.doc begriff.doc binomexp.doc boldtensors.doc bosisio.doc bropd.doc calculation.doc ccfonts.doc commath.doc concmath.doc concrete.doc conteq.doc ebproof.doc eqnarray.doc extarrows.doc extpfeil.doc faktor.doc grundgesetze.doc interval.doc ionumbers.doc isomath.doc logicproof.doc lpform.doc lplfitch.doc mathcomp.doc mattens.doc mhequ.doc multiobjective.doc natded.doc nath.doc ot-tableau.doc oubraces.doc perfectcut.doc prftree.doc proba.doc rec-thy.doc ribbonproofs.doc rmathbr.doc sesamanuel.doc shuffle.doc skmath.doc statex.doc statex2.doc stmaryrd.doc subsupscripts.doc susy.doc syllogism.doc sympytexpackage.doc synproof.doc tablor.doc tensor.doc tex-ewd.doc thmbox.doc turnstile.doc unicode-math.doc venn.doc yhmath.doc ytableau.doc "
TEXLIVE_MODULE_SRC_CONTENTS="12many.source backnaur.source binomexp.source bosisio.source bropd.source calculation.source ccfonts.source concmath.source conteq.source eqnarray.source extpfeil.source faktor.source grundgesetze.source ionumbers.source logicproof.source lplfitch.source mathcomp.source mattens.source multiobjective.source proba.source rmathbr.source sesamanuel.source shuffle.source skmath.source stmaryrd.source sympytexpackage.source tensor.source thmbox.source turnstile.source unicode-math.source yhmath.source ytableau.source "
inherit  texlive-module
DESCRIPTION="TeXLive Mathematics packages"

LICENSE=" BSD GPL-1 GPL-2 GPL-3 LGPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-fontsrecommended-2015
>=dev-texlive/texlive-latex-2015
!<dev-texlive/texlive-latexextra-2015
"
RDEPEND="${DEPEND} "
