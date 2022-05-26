# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg

DESCRIPTION="An emulator for the Sega Dreamcast system"
HOMEPAGE="https://github.com/lxdream/lxdream"
SRC_URI="http://www.lxdream.org/count.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# lirc configure option is not recogniced
IUSE="debug profile pulseaudio sdl" #lirc

RDEPEND="
	app-misc/lirc
	media-libs/alsa-lib
	media-libs/libpng:0=
	virtual/opengl
	x11-libs/gtk+:2
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl[sound] )"
DEPEND="${RDEPEND}
	!!gnustep-base/gnustep-gui" #377635
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	virtual/os-headers"

PATCHES=(
	"${FILESDIR}"/${P}-glib-single-include.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	# Make .desktop file pass desktop-file-validate
	sed -i \
		-e '/Encoding/d' \
		-e '/FilePattern/d' \
		-e '/Categories/s|$|;|' \
		${PN}.desktop || die
	# Do not override user-specified CFLAGS
	sed -i \
		-e s/'CFLAGS=\"-g -fexceptions\"'/'CFLAGS=\"${CFLAGS} -g -fexceptions\"'/ \
		-e '/CCOPT/d' \
		-e '/OBJCOPT/d' \
		configure || die
	append-libs -lX11 -lm
}

src_configure() {
	# lirc configure option is not recognized
	# $(use_with lirc) \
	econf \
		--datadir="${EPREFIX}/usr/share" \
		$(use_enable debug trace) \
		$(use_enable debug watch) \
		$(use_enable profile profiled) \
		$(use_with pulseaudio pulse) \
		$(use_with sdl) \
		--without-esd
}
