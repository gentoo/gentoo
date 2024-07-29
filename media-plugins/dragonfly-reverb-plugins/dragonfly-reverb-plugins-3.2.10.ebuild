# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A set of free reverb effects"
HOMEPAGE="https://michaelwillis.github.io/dragonfly-reverb/"
SRC_URI="https://github.com/michaelwillis/dragonfly-reverb/releases/download/${PV}/${PN%-plugins}-${PV}-src.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libglvnd
	virtual/jack
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXext
	x11-libs/libXrandr
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN%-plugins}-${PV}"

src_prepare() {
	default
	sed -i '/^BASE_OPTS/s/-O3//' dpf/Makefile.base.mk || die
}

src_compile() {
	emake SKIP_STRIPPING=true
}

src_install() {
	cd bin || die
	for plugin in DragonflyEarlyReflections DragonflyHallReverb DragonflyPlateReverb DragonflyRoomReverb; do
		for kind in clap lv2 vst3; do
			insinto	"/usr/$(get_libdir)/${kind}"
			doins -r "${plugin}.${kind}"
		done
	done
}
