# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

# Note to maintainers:
# The upstream tarball is huge (over 780 MB), so we repackage the
# regional subset OTF fonts per region, for the user's convenience.

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"
SRC_URI="cjk? ( https://dev.gentoo.org/~yngwin/distfiles/${PN}-ja-${PV}.tar.xz
		https://dev.gentoo.org/~yngwin/distfiles/${PN}-ko-${PV}.tar.xz
		https://dev.gentoo.org/~yngwin/distfiles/${PN}-zh_CN-${PV}.tar.xz
		https://dev.gentoo.org/~yngwin/distfiles/${PN}-zh_TW-${PV}.tar.xz )
	linguas_ja? ( https://dev.gentoo.org/~yngwin/distfiles/${PN}-ja-${PV}.tar.xz )
	linguas_ko? ( https://dev.gentoo.org/~yngwin/distfiles/${PN}-ko-${PV}.tar.xz )
	linguas_zh_CN? ( https://dev.gentoo.org/~yngwin/distfiles/${PN}-zh_CN-${PV}.tar.xz )
	linguas_zh_TW? ( https://dev.gentoo.org/~yngwin/distfiles/${PN}-zh_TW-${PV}.tar.xz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x64-macos"
IUSE="cjk linguas_ja linguas_ko +linguas_zh_CN linguas_zh_TW"
REQUIRED_USE="|| ( cjk linguas_ja linguas_ko linguas_zh_CN linguas_zh_TW )"

S=${WORKDIR}
FONT_SUFFIX="otf"
RESTRICT="binchecks strip"

src_install() {
	for l in ja ko zh_CN zh_TW; do
		( use cjk || use linguas_${l} ) \
			&& FONT_S="${S}/source-han-sans-${l}-${PV}" font_src_install
	done
	dodoc source-han-sans-*-${PV}/*md source-han-sans-*-${PV}/*pdf
}
