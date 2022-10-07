# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font optfeature

# Note to maintainers:
# The upstream tarball is huge (over 780 MB), so we use the
# regional subset OTF fonts per region, for the user's convenience.

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"
SRC_URI="
	l10n_ja? ( https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/SourceHanSansJP.zip -> ${PN}-ja-${PV}.zip )
	l10n_ko? ( https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/SourceHanSansKR.zip -> ${PN}-ko-${PV}.zip )
	l10n_zh-CN? ( https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/SourceHanSansCN.zip -> ${PN}-zh_CN-${PV}.zip )
	l10n_zh-HK? ( https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/SourceHanSansHK.zip -> ${PN}-zh_HK-${PV}.zip )
	l10n_zh-TW? ( https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/SourceHanSansTW.zip -> ${PN}-zh_TW-${PV}.zip )"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="l10n_ja l10n_ko +l10n_zh-CN l10n_zh-HK l10n_zh-TW"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-HK l10n_zh-TW )"
RESTRICT="binchecks strip"

FONT_SUFFIX="otf"

BDEPEND="app-arch/unzip"

src_install() {
	use l10n_ja && FONT_S="${S}/SubsetOTF/JP" font_src_install
	use l10n_ko && FONT_S="${S}/SubsetOTF/KR" font_src_install
	use l10n_zh-CN && FONT_S="${S}/SubsetOTF/CN" font_src_install
	use l10n_zh-HK && FONT_S="${S}/SubsetOTF/HK" font_src_install
	use l10n_zh-TW && FONT_S="${S}/SubsetOTF/TW" font_src_install
}

pkg_postinst() {
	optfeature_header "Other variants of this font are:"
	optfeature "the monospace variant" media-fonts/source-code-pro
	optfeature "the sans-serif variant" media-fonts/source-sans
	optfeature "the serif variant" media-fonts/source-serif
}
