# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps toolchain-funcs

DESCRIPTION="generates a status bar for dzen2, xmobar or similar"
HOMEPAGE="https://i3wm.org/i3status/"
SRC_URI="https://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="pulseaudio"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/confuse:=
	dev-libs/libnl:3
	>=dev-libs/yajl-2.0.2
	media-libs/alsa-lib
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.11-pulseaudio.patch )

src_prepare() {
	default
	sed -e "/@echo/d" -e "s:@\$(:\$(:g" -e "/setcap/d" \
		-e '/CFLAGS+=-g/d' -i Makefile || die
}

src_compile() {
	emake V=1 CC="$(tc-getCC)" PULSE=$(usex pulseaudio 1 0)
}

pkg_postinst() {
	fcaps cap_net_admin usr/bin/${PN}
	einfo "${PN} can be used with any of the following programs:"
	einfo "   i3bar (x11-wm/i3)"
	einfo "   x11-misc/xmobar"
	einfo "   x11-misc/dzen"
	einfo "Please refer to manual: man ${PN}"
}
