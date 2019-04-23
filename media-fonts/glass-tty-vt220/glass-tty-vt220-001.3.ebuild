# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Hacking with Style: TrueType VT220 Font"
HOMEPAGE="http://sensi.org/~svo/glasstty/"
SRC_URI="http://sensi.org/~svo/glasstty/Glass_TTY_VT220.ttf -> Glass_TTY_VT220-${PV}.ttf"

KEYWORDS="amd64 ~arm arm64 x86"
LICENSE="freedist"
SLOT="0"

RESTRICT="mirror"

S="${DISTDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	return
}

pkg_postinst() {
	einfo "When using the GlassTTY VT220 font, you must set the font size to 15."
}
