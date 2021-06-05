# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="alkalami alpha-persian amiri arabi arabi-add arabluatex arabtex bidi bidihl dad ghab hvarabic hyphen-arabic hyphen-farsi imsproc kurdishlipsum lshort-persian luabidi na-box persian-bib quran sexam simurgh texnegar tram xepersian xepersian-hm collection-langarabic
"
TEXLIVE_MODULE_DOC_CONTENTS="alkalami.doc alpha-persian.doc amiri.doc arabi.doc arabi-add.doc arabluatex.doc arabtex.doc bidi.doc bidihl.doc dad.doc ghab.doc hvarabic.doc imsproc.doc kurdishlipsum.doc lshort-persian.doc luabidi.doc na-box.doc persian-bib.doc quran.doc sexam.doc simurgh.doc texnegar.doc tram.doc xepersian.doc xepersian-hm.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabluatex.source bidi.source texnegar.source xepersian.source xepersian-hm.source "
inherit  texlive-module
DESCRIPTION="TeXLive Arabic"

LICENSE=" GPL-2 GPL-3+ LPPL-1.3 LPPL-1.3c OFL public-domain "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021"

RDEPEND="${DEPEND} "
