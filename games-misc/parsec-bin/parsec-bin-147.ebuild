# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/-bin/}
MY_PN_BIN=${PN/-bin/d}
inherit eutils gnome2-utils unpacker

DESCRIPTION="Low-Latency Game Streaming - Play, watch, and share games with your friends"
HOMEPAGE="https://parsecgaming.com/"
SRC_URI="https://s3.amazonaws.com/parsec-build/package/parsec-linux.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	x11-libs/cairo
	media-libs/freetype
	x11-libs/gdk-pixbuf
	media-libs/mesa
	x11-libs/gtk+
	x11-libs/pango
	x11-libs/libSM
	media-libs/libao
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-terms/xterm
"

S=${WORKDIR}

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
	fperms +x /usr/bin/${MY_PN_BIN}

}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
