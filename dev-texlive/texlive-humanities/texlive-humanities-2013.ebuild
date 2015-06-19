# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-humanities/texlive-humanities-2013.ebuild,v 1.1 2013/06/28 16:17:08 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="alnumsec arydshln bibleref bibleref-lds bibleref-mouth bibleref-parse covington dramatist dvgloss ecltree edfnotes ednotes eledform eledmac gb4e gmverse jura juraabbrev juramisc jurarsp ledmac leipzig lexikon lineno linguex liturg parallel parrun plari play poemscol poetrytex qobitree qtree rrgtrees rtklage screenplay sides stage textglos tree-dvips verse xyling collection-humanities
"
TEXLIVE_MODULE_DOC_CONTENTS="alnumsec.doc arydshln.doc bibleref.doc bibleref-lds.doc bibleref-mouth.doc bibleref-parse.doc covington.doc dramatist.doc dvgloss.doc ecltree.doc edfnotes.doc ednotes.doc eledform.doc eledmac.doc gb4e.doc gmverse.doc jura.doc juraabbrev.doc juramisc.doc jurarsp.doc ledmac.doc leipzig.doc lexikon.doc lineno.doc linguex.doc liturg.doc parallel.doc parrun.doc plari.doc play.doc poemscol.doc poetrytex.doc qobitree.doc qtree.doc rrgtrees.doc rtklage.doc screenplay.doc sides.doc stage.doc textglos.doc tree-dvips.doc verse.doc xyling.doc "
TEXLIVE_MODULE_SRC_CONTENTS="alnumsec.source arydshln.source bibleref.source bibleref-lds.source bibleref-mouth.source dramatist.source dvgloss.source edfnotes.source eledform.source eledmac.source jura.source juraabbrev.source jurarsp.source ledmac.source leipzig.source lineno.source liturg.source parallel.source parrun.source plari.source play.source poemscol.source poetrytex.source rrgtrees.source screenplay.source textglos.source verse.source "
inherit  texlive-module
DESCRIPTION="TeXLive Humanities packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2013
!dev-tex/lineno
"
RDEPEND="${DEPEND} "
