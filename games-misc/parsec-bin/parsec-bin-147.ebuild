# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils unpacker

PARSEC_P="parsec-bin-${PV}"

DESCRIPTION="Simple, Low-Latency Game Streaming - Play, watch, share games with your friends"
HOMEPAGE="https://parsecgaming.com/"
SRC_URI="https://s3.amazonaws.com/parsec-build/package/parsec-linux.deb -> ${PARSEC_P}.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-libs/freetype
	media-libs/libao
	media-libs/mesa
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/pango
	x11-terms/xterm
"

S="${WORKDIR}"

RESTRICT="mirror bindist"

QA_PREBUILT="
	usr/bin/parsecd
	usr/share/parsec/skel/parsecd-147-9.so
"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto usr
	doins -r usr/.
	fperms +x /usr/bin/parsecd
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
