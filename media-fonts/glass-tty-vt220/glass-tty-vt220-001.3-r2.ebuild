# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="8d5bcafe971ee94df4aa20317f197d407df672e9"
MY_PN="glasstty"

inherit font

DESCRIPTION="Hacking with Style: TrueType VT220 Font"
HOMEPAGE="
	http://sensi.org/~svo/glasstty/
	https://github.com/svofski/glasstty
"
SRC_URI="https://github.com/svofski/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 arm arm64 x86"
LICENSE="Unlicense"
SLOT="0"

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_configure() {
	:;
}

src_compile() {
	:;
}

pkg_postinst() {
	font_pkg_postinst

	einfo "Since the GlassTTY VT220 font is fixed,"
	einfo "you must use a font size of 15 for best quality."
}
