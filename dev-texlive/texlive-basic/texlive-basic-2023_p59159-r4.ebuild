# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-basic.r59159
	amsfonts.r61937
	bibtex.r66186
	cm.r57963
	colorprofiles.r49086
	ec.r25033
	enctex.r34957
	etex.r66203
	etex-pkg.r41784
	graphics-def.r64487
	hyph-utf8.r61719
	hyphenex.r57387
	ifplatform.r45533
	iftex.r61910
	knuth-lib.r57963
	knuth-local.r57963
	lua-alt-getopt.r56414
	luahbtex.r66186
	luajittex.r66186
	luatex.r69182
	metafont.r66186
	mflogo.r42428
	mfware.r66186
	modes.r69113
	pdftex.r66243
	plain.r57963
	tex.r66186
	tex-ini-files.r68920
	texlive-msg-translations.r69696
	tlshell.r66771
	unicode-data.r68311
"
TEXLIVE_MODULE_DOC_CONTENTS="
	amsfonts.doc.r61937
	bibtex.doc.r66186
	cm.doc.r57963
	colorprofiles.doc.r49086
	ec.doc.r25033
	enctex.doc.r34957
	etex.doc.r66203
	etex-pkg.doc.r41784
	graphics-def.doc.r64487
	hyph-utf8.doc.r61719
	ifplatform.doc.r45533
	iftex.doc.r61910
	lua-alt-getopt.doc.r56414
	luahbtex.doc.r66186
	luajittex.doc.r66186
	luatex.doc.r69182
	metafont.doc.r66186
	mflogo.doc.r42428
	mfware.doc.r66186
	modes.doc.r69113
	pdftex.doc.r66243
	tex.doc.r66186
	tex-ini-files.doc.r68920
	texlive-common.doc.r68510
	texlive-en.doc.r67184
	tlshell.doc.r66771
	unicode-data.doc.r68311
"
TEXLIVE_MODULE_SRC_CONTENTS="
	amsfonts.source.r61937
	hyph-utf8.source.r61719
	hyphenex.source.r57387
	ifplatform.source.r45533
	mflogo.source.r42428
"

TEXLIVE_MODULE_OPTIONAL_ENGINE="luajittex"

inherit texlive-module

DESCRIPTION="TeXLive Essential programs and files"

LICENSE="GPL-1+ GPL-2+ LGPL-2.1 LPPL-1.0 LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
COMMON_DEPEND="
	>=app-text/texlive-core-2023[luajittex?]
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/dvipsk-2023.03.11_p66203
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/simpdftex/simpdftex
	texmf-dist/scripts/tlshell/tlshell.tcl
"

src_prepare() {
	default
	if ! use luajittex; then
		rm -rf texmf-dist/{,scripts,doc}/luajittex
		rm tlpkg/tlpobj/luajittex.* || die
	fi
}
