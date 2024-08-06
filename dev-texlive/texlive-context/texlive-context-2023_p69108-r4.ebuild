# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-context.r69108
	context.r69665
	context-calendar-examples.r66947
	context-collating-marks.r68696
	context-cyrillicnumbers.r47085
	context-filter.r62070
	context-gnuplot.r47085
	context-handlecsv.r69186
	context-legacy.r69173
	context-letter.r60787
	context-mathsets.r47085
	context-pocketdiary.r66953
	context-simpleslides.r67070
	context-squares.r68545
	context-sudoku.r67289
	context-texlive.r66924
	context-transliterator.r61127
	context-typescripts.r60422
	context-vim.r62071
	context-visualcounter.r47085
	jmn.r45751
"
TEXLIVE_MODULE_DOC_CONTENTS="
	context.doc.r69665
	context-calendar-examples.doc.r66947
	context-collating-marks.doc.r68696
	context-cyrillicnumbers.doc.r47085
	context-filter.doc.r62070
	context-gnuplot.doc.r47085
	context-handlecsv.doc.r69186
	context-legacy.doc.r69173
	context-letter.doc.r60787
	context-mathsets.doc.r47085
	context-notes-zh-cn.doc.r66725
	context-pocketdiary.doc.r66953
	context-simpleslides.doc.r67070
	context-squares.doc.r68545
	context-sudoku.doc.r67289
	context-transliterator.doc.r61127
	context-typescripts.doc.r60422
	context-vim.doc.r62071
	context-visualcounter.doc.r47085
"
TEXLIVE_MODULE_SRC_CONTENTS="
	context-visualcounter.source.r47085
"

inherit greadme texlive-module

DESCRIPTION="TeXLive ConTeXt and packages"

LICENSE="BSD BSD-2 GPL-1+ GPL-2 GPL-3 LGPL-2+ LPPL-1.3 LPPL-1.3c MIT TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/ruby
"
DEPEND="
	${COMMON_DEPEND}
	>=app-text/texlive-core-2023[xetex]
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/context/stubs-mkiv/unix/contextjit
	texmf-dist/scripts/context/stubs-mkiv/unix/luatools
	texmf-dist/scripts/context/stubs-mkiv/unix/mtxrunjit

	texmf-dist/scripts/context/stubs/unix/texexec
	texmf-dist/scripts/context/stubs/unix/texmfstart
"

src_prepare() {
	default
	# No need to install these .exe
	rm -rf texmf-dist/scripts/context/stubs/{mswin,win64} || die
}

src_install() {
	texlive-module_src_install

	local mtxrun=/usr/share/texmf-dist/scripts/context/lua/mtxrun.lua
	fperms 755 "${mtxrun}"
	newbin - mtxrun <<-EOF
	#!/bin/sh
	export TEXMF_DIST="${EPREFIX}/usr/share/texmf-dist"
	exec ${mtxrun} "\$@"
EOF

	newbin - context <<-EOF
	#!/bin/sh
	exec mtxrun --script context "\$@"
EOF

	greadme_stdin <<-EOF
	For using ConTeXt mkII simply use 'texexec' to generate your documents.
	If you plan to use mkIV and its 'context' command to generate your documents,
	you have to run 'mtxrun --generate' as normal user before first use.

	More information and advanced options on:
	http://wiki.contextgarden.net/TeX_Live_2011
EOF
}

pkg_postinst() {
	texlive-module_pkg_postinst
	greadme_pkg_postinst
}
