# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-basic.r72890
	amsfonts.r61937
	bibtex.r70015
	cm.r57963
	colorprofiles.r49086
	ec.r25033
	enctex.r34957
	etex.r70440
	etex-pkg.r41784
	graphics-def.r70970
	hyph-utf8.r61719
	hyphenex.r57387
	ifplatform.r45533
	iftex.r61910
	knuth-lib.r57963
	knuth-local.r57963
	lua-alt-getopt.r56414
	luahbtex.r71409
	luajittex.r71409
	luatex.r71409
	metafont.r70015
	mflogo.r42428
	mfware.r70015
	modes.r69113
	pdftex.r71605
	plain.r57963
	tex.r70015
	tex-ini-files.r68920
	texlive-msg-translations.r71858
	tlshell.r70419
	unicode-data.r68311
"
TEXLIVE_MODULE_DOC_CONTENTS="
	amsfonts.doc.r61937
	bibtex.doc.r70015
	cm.doc.r57963
	colorprofiles.doc.r49086
	ec.doc.r25033
	enctex.doc.r34957
	etex.doc.r70440
	etex-pkg.doc.r41784
	graphics-def.doc.r70970
	hyph-utf8.doc.r61719
	ifplatform.doc.r45533
	iftex.doc.r61910
	lua-alt-getopt.doc.r56414
	luahbtex.doc.r71409
	luajittex.doc.r71409
	luatex.doc.r71409
	metafont.doc.r70015
	mflogo.doc.r42428
	mfware.doc.r70015
	modes.doc.r69113
	pdftex.doc.r71605
	tex.doc.r70015
	tex-ini-files.doc.r68920
	texlive-common.doc.r72854
	texlive-en.doc.r71152
	tlshell.doc.r70419
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

LICENSE="GPL-1+ GPL-2+ LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"
COMMON_DEPEND="
	>=app-text/texlive-core-2024[luajittex?]
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/dvipsk-2024.03.11_p70015
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
