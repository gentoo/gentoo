# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-mathextra/texlive-mathextra-2012-r1.ebuild,v 1.13 2013/04/25 21:29:17 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="12many amstex binomexp boldtensors bosisio ccfonts
commath concmath concrete eqnarray extarrows extpfeil faktor ionumbers isomath
mathcomp mattens mhequ multiobjective nath ot-tableau oubraces proba rec-thy
shuffle statex statex2 stmaryrd subsupscripts susy syllogism synproof tablor
tensor tex-ewd thmbox turnstile unicode-math07a venn yhmath ytableau collection-mathextra
"
TEXLIVE_MODULE_DOC_CONTENTS="12many.doc amstex.doc binomexp.doc boldtensors.doc
bosisio.doc ccfonts.doc commath.doc concmath.doc concrete.doc eqnarray.doc
extarrows.doc extpfeil.doc faktor.doc ionumbers.doc isomath.doc mathcomp.doc
mattens.doc mhequ.doc multiobjective.doc nath.doc ot-tableau.doc oubraces.doc
proba.doc rec-thy.doc shuffle.doc statex.doc statex2.doc stmaryrd.doc
subsupscripts.doc susy.doc syllogism.doc synproof.doc tablor.doc tensor.doc
tex-ewd.doc thmbox.doc turnstile.doc unicode-math07a.doc venn.doc yhmath.doc ytableau.doc "
TEXLIVE_MODULE_SRC_CONTENTS="12many.source binomexp.source bosisio.source
ccfonts.source concmath.source eqnarray.source extpfeil.source faktor.source
ionumbers.source mathcomp.source mattens.source multiobjective.source
proba.source shuffle.source stmaryrd.source tensor.source thmbox.source
turnstile.source unicode-math07a.source yhmath.source ytableau.source "
inherit  texlive-module
DESCRIPTION="TeXLive Advanced math typesetting"

LICENSE="GPL-2 BSD GPL-1 GPL-3 LGPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-fontsrecommended-2012
>=dev-texlive/texlive-latex-2012
!<dev-texlive/texlive-latexextra-2010
"
RDEPEND="${DEPEND} "
