# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

# Note to maintainers:
# The upstream tarball is huge (over 780 MB), so we repackage the
# regional subset OTF fonts per region, for the user's convenience.

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"
SRC_URI="l10n_ja? ( https://dev.gentoo.org/~jstein/dist/${PN}-ja-${PV}.tar.xz )
	l10n_ko? ( https://dev.gentoo.org/~jstein/dist/${PN}-ko-${PV}.tar.xz )
	l10n_zh-CN? ( https://dev.gentoo.org/~jstein/dist/${PN}-zh_CN-${PV}.tar.xz )
	l10n_zh-TW? ( https://dev.gentoo.org/~jstein/dist/${PN}-zh_TW-${PV}.tar.xz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 ~sh sparc x86 ~x64-macos"
IUSE="l10n_ja l10n_ko +l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"

S=${WORKDIR}
FONT_SUFFIX="otf"
RESTRICT="binchecks strip"

src_install() {
	local l
	for l in ja ko zh-CN zh-TW; do
		use l10n_${l} && FONT_S="${S}/source-han-sans-${l//-/_}-${PV}" font_src_install
	done
	dodoc source-han-sans-*-${PV}/*md source-han-sans-*-${PV}/*pdf
}
