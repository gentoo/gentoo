# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langcjk.r65824
	adobemapping.r66552
	c90.r60830
	cjk.r60865
	cjk-gs-integrate.r59705
	cjkpunct.r41119
	cjkutils.r60833
	dnp.r54074
	evangelion-jfm.r69751
	fixjfm.r63967
	garuda-c90.r60832
	jfmutil.r60987
	norasi-c90.r60831
	pxtatescale.r63967
	xcjk2uni.r54958
	xecjk.r64059
	zitie.r60676
	zxjafont.r62864
"
TEXLIVE_MODULE_DOC_CONTENTS="
	c90.doc.r60830
	cjk.doc.r60865
	cjk-gs-integrate.doc.r59705
	cjkpunct.doc.r41119
	cjkutils.doc.r60833
	evangelion-jfm.doc.r69751
	fixjfm.doc.r63967
	jfmutil.doc.r60987
	pxtatescale.doc.r63967
	xcjk2uni.doc.r54958
	xecjk.doc.r64059
	zitie.doc.r60676
	zxjafont.doc.r62864
"
TEXLIVE_MODULE_SRC_CONTENTS="
	c90.source.r60830
	cjk.source.r60865
	cjk-gs-integrate.source.r59705
	cjkpunct.source.r41119
	evangelion-jfm.source.r69751
	garuda-c90.source.r60832
	norasi-c90.source.r60831
	xcjk2uni.source.r54958
	xecjk.source.r64059
"

inherit texlive-module

DESCRIPTION="TeXLive Chinese/Japanese/Korean (base)"

LICENSE="BSD FDL-1.1 GPL-1 GPL-2 GPL-2+ GPL-3 LPPL-1.3 LPPL-1.3c MIT TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=app-text/texlive-core-2023[cjk]
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/cjk-gs-integrate/cjk-gs-integrate.pl
	texmf-dist/scripts/jfmutil/jfmutil.pl
"
