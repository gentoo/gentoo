# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font optfeature

# Note to maintainers:
# The upstream tarball is huge (over 780 MB), so we use the
# regional subset OTF fonts per region, for the user's convenience.

SRC_PREFIX="https://github.com/adobe-fonts/source-han-sans/releases/download/${PV}R"

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans"
SRC_URI="
	language? (
		l10n_ja? ( ${SRC_PREFIX}/07_SourceHanSansJ.zip -> ${PN}-j-${PV}.zip )
		l10n_ko? ( ${SRC_PREFIX}/08_SourceHanSansK.zip -> ${PN}-k-${PV}.zip )
		l10n_zh-CN? ( ${SRC_PREFIX}/09_SourceHanSansSC.zip -> ${PN}-sc-${PV}.zip )
		l10n_zh-TW? ( ${SRC_PREFIX}/10_SourceHanSansTC.zip -> ${PN}-tc-${PV}.zip )
		l10n_zh-HK? ( ${SRC_PREFIX}/11_SourceHanSansHC.zip -> ${PN}-hc-${PV}.zip )
	)
	half-width? (
		l10n_ja? ( ${SRC_PREFIX}/12_SourceHanSansHWJ.zip -> ${PN}-hw-j-${PV}.zip )
		l10n_ko? ( ${SRC_PREFIX}/13_SourceHanSansHWK.zip -> ${PN}-hw-k-${PV}.zip )
		l10n_zh-CN? ( ${SRC_PREFIX}/14_SourceHanSansHWSC.zip -> ${PN}-hw-sc-${PV}.zip )
		l10n_zh-TW? ( ${SRC_PREFIX}/15_SourceHanSansHWTC.zip -> ${PN}-hw-tc-${PV}.zip )
		l10n_zh-HK? ( ${SRC_PREFIX}/16_SourceHanSansHWHC.zip -> ${PN}-hw-hc-${PV}.zip )
	)
	region? (
		l10n_ja? ( ${SRC_PREFIX}/17_SourceHanSansJP.zip -> ${PN}-jp-${PV}.zip )
		l10n_ko? ( ${SRC_PREFIX}/18_SourceHanSansKR.zip -> ${PN}-kr-${PV}.zip )
		l10n_zh-CN? ( ${SRC_PREFIX}/19_SourceHanSansCN.zip -> ${PN}-cn-${PV}.zip )
		l10n_zh-TW? ( ${SRC_PREFIX}/20_SourceHanSansTW.zip -> ${PN}-tw-${PV}.zip )
		l10n_zh-HK? ( ${SRC_PREFIX}/21_SourceHanSansHK.zip -> ${PN}-hk-${PV}.zip )
	)
"

S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

IUSE="language half-width +region l10n_ja l10n_ko +l10n_zh-CN l10n_zh-HK l10n_zh-TW"
REQUIRED_USE="|| ( language half-width region ) || ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-HK l10n_zh-TW )"
RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="otf"

src_install() {
	if use language; then
		use l10n_ja && FONT_S="OTF/Japanese" font_src_install
		use l10n_ko && FONT_S="OTF/Korean" font_src_install
		use l10n_zh-CN && FONT_S="OTF/SimplifiedChinese" font_src_install
		use l10n_zh-TW && FONT_S="OTF/TraditionalChinese" font_src_install
		use l10n_zh-HK && FONT_S="OTF/TraditionalChineseHK" font_src_install
	fi
	if use half-width; then
		use l10n_ja && FONT_S="OTF/JapaneseHW" font_src_install
		use l10n_ko && FONT_S="OTF/KoreanHW" font_src_install
		use l10n_zh-CN && FONT_S="OTF/SimplifiedChineseHW" font_src_install
		use l10n_zh-TW && FONT_S="OTF/TraditionalChineseHW" font_src_install
		use l10n_zh-HK && FONT_S="OTF/TraditionalChineseHKHW" font_src_install
	fi
	if use region; then
		use l10n_ja && FONT_S="SubsetOTF/JP" font_src_install
		use l10n_ko && FONT_S="SubsetOTF/KR" font_src_install
		use l10n_zh-CN && FONT_S="SubsetOTF/CN" font_src_install
		use l10n_zh-TW && FONT_S="SubsetOTF/TW" font_src_install
		use l10n_zh-HK && FONT_S="SubsetOTF/HK" font_src_install
	fi
}

pkg_postinst() {
	font_pkg_postinst

	optfeature_header "Other variants of this font are:"
	optfeature "the monospace variant" media-fonts/source-code-pro
	optfeature "the sans-serif variant" media-fonts/source-sans
	optfeature "the serif variant" media-fonts/source-serif
}
