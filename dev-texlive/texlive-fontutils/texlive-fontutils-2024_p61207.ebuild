# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-fontutils.r61207
	accfonts.r18835
	afm2pl.r71515
	albatross.r69832
	dosepsbin.r29752
	dvipsconfig.r13293
	epstopdf.r71782
	fontinst.r62517
	fontools.r69241
	fontware.r70015
	luafindfont.r72111
	mf2pt1.r71883
"
TEXLIVE_MODULE_DOC_CONTENTS="
	accfonts.doc.r18835
	afm2pl.doc.r71515
	albatross.doc.r69832
	dosepsbin.doc.r29752
	epstopdf.doc.r71782
	fontinst.doc.r62517
	fontools.doc.r69241
	fontware.doc.r70015
	luafindfont.doc.r72111
	mf2pt1.doc.r71883
"
TEXLIVE_MODULE_SRC_CONTENTS="
	albatross.source.r69832
	dosepsbin.source.r29752
	fontinst.source.r62517
	metatype1.source.r37105
"

inherit texlive-module

DESCRIPTION="TeXLive Graphics and font utilities"

LICENSE="Artistic BSD GPL-1+ GPL-2 LPPL-1.3c TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="amd64"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2024
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/ps2pkm-1.8_p20240311
	>=app-text/ttf2pk2-2.0_p20240311
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/accfonts/mkt1font
	texmf-dist/scripts/accfonts/vpl2ovp
	texmf-dist/scripts/accfonts/vpl2vpl
	texmf-dist/scripts/albatross/albatross.sh
	texmf-dist/scripts/dosepsbin/dosepsbin.pl
	texmf-dist/scripts/epstopdf/epstopdf.pl
	texmf-dist/scripts/fontools/afm2afm
	texmf-dist/scripts/fontools/autoinst
	texmf-dist/scripts/fontools/ot2kpx
	texmf-dist/scripts/luafindfont/luafindfont.lua
	texmf-dist/scripts/mf2pt1/mf2pt1.pl
	texmf-dist/scripts/texlive-extra/fontinst.sh
"

TEXLIVE_MODULE_BINLINKS="
	epstopdf:repstopdf
"
