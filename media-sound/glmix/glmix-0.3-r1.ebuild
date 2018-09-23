# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A 3D widget for mixing up to eight JACK audio streams down to stereo"
HOMEPAGE="https://devel.tlrmx.org/audio"
SRC_URI="https://devel.tlrmx.org/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="media-sound/jack-audio-connection-kit
	>=x11-libs/gtkglext-1
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	local libs="gtk+-2.0 gtkglext-1.0 jack pango"
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} $(pkg-config --cflags ${libs})" \
		LDFLAGS="-lm ${LDFLAGS} $(pkg-config --libs ${libs})"
}

src_install() {
	dobin ${PN}
	dodoc README TODO
	make_desktop_entry ${PN} "GL Mixer"
}
