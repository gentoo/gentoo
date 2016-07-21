# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs versionator fcaps

DESCRIPTION="generates a status bar for dzen2, xmobar or similar"
HOMEPAGE="http://i3wm.org/i3status/"
SRC_URI="http://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/confuse:=
	>=dev-libs/yajl-2.0.2
	media-libs/alsa-lib
	net-wireless/wireless-tools"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "/@echo/d" -e "s:@\$(:\$(:g" -e "/setcap/d" \
		-e '/CFLAGS+=-g/d' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

pkg_postinst() {
	fcaps cap_net_admin usr/bin/${PN}
	einfo "${PN} can be used with any of the following programs:"
	einfo "   i3bar (x11-wm/i3)"
	einfo "   x11-misc/xmobar"
	einfo "   x11-misc/dzen"
	einfo "Please refer to manual: man ${PN}"
}
