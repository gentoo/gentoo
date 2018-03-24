# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

TEXLIVE_MODULE_CONTENTS="abbr abstyles autoaligne barr bitelist borceux c-pascal catcodes chronosys colorsep dinat dirtree docbytex dowith eijkhout encxvlna epigram fenixpar fltpoint fntproof gates gobble gtl ifetex iftex insbox lambda-lists langcode lecturer librarian listofitems mathdots metatex midnight navigator ofs olsak-misc pdf-trans plainpkg randomlist schemata shade systeme tabto-generic termmenu tracklang texapi upca xlop yax collection-genericextra
"
TEXLIVE_MODULE_DOC_CONTENTS="abbr.doc abstyles.doc autoaligne.doc barr.doc bitelist.doc borceux.doc c-pascal.doc catcodes.doc chronosys.doc dinat.doc dirtree.doc docbytex.doc dowith.doc encxvlna.doc fenixpar.doc fltpoint.doc fntproof.doc gates.doc gobble.doc gtl.doc ifetex.doc iftex.doc insbox.doc lambda-lists.doc langcode.doc lecturer.doc librarian.doc listofitems.doc mathdots.doc metatex.doc midnight.doc navigator.doc ofs.doc olsak-misc.doc pdf-trans.doc plainpkg.doc randomlist.doc schemata.doc shade.doc systeme.doc termmenu.doc tracklang.doc texapi.doc upca.doc xlop.doc yax.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bitelist.source catcodes.source dirtree.source dowith.source fltpoint.source gobble.source gtl.source ifetex.source langcode.source mathdots.source plainpkg.source randomlist.source schemata.source termmenu.source tracklang.source xlop.source "
inherit  texlive-module
DESCRIPTION="TeXLive Generic additional packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2016
!<dev-texlive/texlive-latexextra-2016
"
RDEPEND="${DEPEND} "
