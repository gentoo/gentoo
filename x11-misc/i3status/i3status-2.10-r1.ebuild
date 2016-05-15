# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs fcaps

DESCRIPTION="generates a status bar for dzen2, xmobar or similar"
HOMEPAGE="http://i3wm.org/i3status/"
SRC_URI="http://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio"

RDEPEND="dev-libs/confuse
	dev-libs/libnl:3
	>=dev-libs/yajl-2.0.2
	media-libs/alsa-lib
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pulseaudio.patch
	sed -e "/@echo/d" -e "s:@\$(:\$(:g" -e "/setcap/d" \
		-e '/CFLAGS+=-g/d' -i Makefile || die
	rm -rf man/${PN}.1  # man not regenerated in tarball
}

src_compile() {
	emake CC="$(tc-getCC)" PULSE=$(usex pulseaudio 1 0)
}

pkg_postinst() {
	fcaps cap_net_admin usr/bin/${PN}
	einfo "${PN} can be used with any of the following programs:"
	einfo "   i3bar (x11-wm/i3)"
	einfo "   x11-misc/xmobar"
	einfo "   x11-misc/dzen"
	einfo "Please refer to manual: man ${PN}"
}
