# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-fontutils.r61207
	accfonts.r18835
	afm2pl.r66186
	albatross.r65647
	dosepsbin.r29752
	dvipsconfig.r13293
	epstopdf.r68301
	fontinst.r62517
	fontools.r69241
	fontware.r66186
	lcdftypetools.r52851
	luafindfont.r67468
	mf2pt1.r61217
	ps2eps.r62856
	psutils.r61719
	t1utils.r57972
"
TEXLIVE_MODULE_DOC_CONTENTS="
	accfonts.doc.r18835
	afm2pl.doc.r66186
	albatross.doc.r65647
	dosepsbin.doc.r29752
	epstopdf.doc.r68301
	fontinst.doc.r62517
	fontools.doc.r69241
	fontware.doc.r66186
	lcdftypetools.doc.r52851
	luafindfont.doc.r67468
	mf2pt1.doc.r61217
	ps2eps.doc.r62856
	psutils.doc.r61719
	t1utils.doc.r57972
"
TEXLIVE_MODULE_SRC_CONTENTS="
	albatross.source.r65647
	dosepsbin.source.r29752
	fontinst.source.r62517
	metatype1.source.r37105
"

inherit texlive-module

DESCRIPTION="TeXLive Graphics and font utilities"

LICENSE="Artistic BSD GPL-1 GPL-2 LPPL-1.3c TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/ps2pkm-1.8_p20230311
	>=app-text/ttf2pk2-2.0_p20230311
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
