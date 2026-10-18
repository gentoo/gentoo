# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-basic.r72890
	amsfonts.r77682
	bibtex.r77830
	cm.r57963
	colorprofiles.r49086
	ec.r25033
	enctex.r34957
	etex.r77830
	etex-pkg.r77682
	graphics-def.r76719
	hyph-utf8.r79618
	hyphenex.r57387
	ifplatform.r77682
	iftex.r77682
	knuth-lib.r57963
	knuth-local.r57963
	lua-alt-getopt.r78415
	luahbtex.r77830
	luajittex.r78968
	luatex.r78218
	metafont.r77830
	mflogo.r79618
	mfware.r77830
	modes.r77365
	pdftex.r79618
	plain.r75712
	tex.r77830
	tex-ini-files.r78524
	texlive-msg-translations.r78661
	tlshell.r78053
	unicode-data.r76413
"
TEXLIVE_MODULE_SRC_CONTENTS="
	amsfonts.doc.r77682
	bibtex.doc.r77830
	cm.doc.r57963
	colorprofiles.doc.r49086
	ec.doc.r25033
	enctex.doc.r34957
	etex.doc.r77830
	etex-pkg.doc.r77682
	graphics-def.doc.r76719
	hyph-utf8.doc.r79618
	ifplatform.doc.r77682
	iftex.doc.r77682
	lua-alt-getopt.doc.r78415
	luahbtex.doc.r77830
	luajittex.doc.r78968
	luatex.doc.r78218
	metafont.doc.r77830
	mflogo.doc.r79618
	mfware.doc.r77830
	modes.doc.r77365
	pdftex.doc.r79618
	tex.doc.r77830
	tex-ini-files.doc.r78524
	texlive-common.doc.r79648
	texlive-en.doc.r79177
	tlshell.doc.r78053
	unicode-data.doc.r76413
"
TEXLIVE_MODULE_DOC_CONTENTS="
	amsfonts.source.r77682
	hyph-utf8.source.r79618
	hyphenex.source.r57387
	ifplatform.source.r77682
	mflogo.source.r79618
"

TEXLIVE_MODULE_OPTIONAL_ENGINE="luajittex"

inherit texlive-module

DESCRIPTION="TeXLive Essential programs and files"

LICENSE="GPL-1+ GPL-2+ LPPL-1.0 LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=app-text/texlive-core-2026[luajittex?]
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/dvipsk-2026.03.01_p77830
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
