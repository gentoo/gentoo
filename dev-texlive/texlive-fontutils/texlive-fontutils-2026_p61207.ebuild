# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-fontutils.r61207
	accfonts.r18835
	afm2pl.r71515
	albatross.r79618
	dosepsbin.r29752
	dvipsconfig.r13293
	epstopdf.r71782
	fontinst.r79618
	fontools.r79613
	fontware.r77830
	luafindfont.r75679
	mf2pt1.r71883
"
TEXLIVE_MODULE_SRC_CONTENTS="
	accfonts.doc.r18835
	afm2pl.doc.r71515
	albatross.doc.r79618
	dosepsbin.doc.r29752
	epstopdf.doc.r71782
	fontinst.doc.r79618
	fontools.doc.r79613
	fontware.doc.r77830
	luafindfont.doc.r75679
	mf2pt1.doc.r71883
"
TEXLIVE_MODULE_DOC_CONTENTS="
	albatross.source.r79618
	dosepsbin.source.r29752
	fontinst.source.r79618
	metatype1.source.r37105
"

inherit texlive-module

DESCRIPTION="TeXLive Graphics and font utilities"

LICENSE="Artistic BSD GPL-1+ GPL-2 LPPL-1.1 LPPL-1.3c TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/ps2pkm-1.8_p20260301
	>=app-text/ttf2pk2-2.0_p20260301
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
