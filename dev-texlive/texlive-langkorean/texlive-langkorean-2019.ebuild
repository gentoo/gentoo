# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="baekmuk cjk-ko kotex-oblivoir kotex-plain kotex-utf kotex-utils lshort-korean nanumtype1 uhc unfonts-core unfonts-extra collection-langkorean
"
TEXLIVE_MODULE_DOC_CONTENTS="baekmuk.doc cjk-ko.doc kotex-oblivoir.doc kotex-plain.doc kotex-utf.doc kotex-utils.doc lshort-korean.doc nanumtype1.doc uhc.doc unfonts-core.doc unfonts-extra.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Korean"

LICENSE=" FDL-1.1 GPL-2 LPPL-1.3 OFL TeX-other-free "
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2019
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/kotex-utils/komkindex.pl texmf-dist/scripts/kotex-utils/jamo-normalize.pl texmf-dist/scripts/kotex-utils/ttf2kotexfont.pl"
