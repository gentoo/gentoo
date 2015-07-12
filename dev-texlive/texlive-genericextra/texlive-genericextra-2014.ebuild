# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-genericextra/texlive-genericextra-2014.ebuild,v 1.2 2015/07/12 15:45:12 ago Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="abbr abstyles bagpipe barr bitelist borceux c-pascal catcodes chronosys colorsep dinat dirtree docbytex dowith eijkhout encxvlna epigram fenixpar fltpoint fntproof gates ifetex iftex insbox lambda-lists langcode lecturer librarian mathdots metatex midnight navigator ofs pdf-trans plainpkg schemata shade systeme tabto-generic tracklang texapi upca xlop yax collection-genericextra
"
TEXLIVE_MODULE_DOC_CONTENTS="abbr.doc abstyles.doc bagpipe.doc barr.doc bitelist.doc borceux.doc c-pascal.doc catcodes.doc chronosys.doc dinat.doc dirtree.doc docbytex.doc dowith.doc encxvlna.doc fenixpar.doc fltpoint.doc fntproof.doc gates.doc ifetex.doc iftex.doc insbox.doc lambda-lists.doc langcode.doc lecturer.doc librarian.doc mathdots.doc metatex.doc midnight.doc navigator.doc ofs.doc pdf-trans.doc plainpkg.doc schemata.doc shade.doc systeme.doc tracklang.doc texapi.doc upca.doc xlop.doc yax.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bitelist.source catcodes.source dirtree.source dowith.source fltpoint.source ifetex.source langcode.source mathdots.source plainpkg.source schemata.source tracklang.source xlop.source "
inherit  texlive-module
DESCRIPTION="TeXLive Generic additional packages"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
"
RDEPEND="${DEPEND} "
