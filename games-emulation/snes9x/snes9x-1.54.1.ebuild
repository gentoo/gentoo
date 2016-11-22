# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic multilib gnome2-utils

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="https://github.com/snes9xgit/snes9x"
SRC_URI="https://github.com/snes9xgit/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="alsa debug gtk joystick multilib netplay nls opengl oss png pulseaudio portaudio +xv +xrandr"
RESTRICT="bindist"

RDEPEND="
	sys-libs/zlib[minizip]
	x11-libs/libX11
	x11-libs/libXext
	png? ( >=media-libs/libpng-1.2.43:0 )
	gtk? ( >=x11-libs/gtk+-2.10:2
		x11-misc/xdg-utils
		portaudio? ( >=media-libs/portaudio-19_pre )
		joystick? ( >=media-libs/libsdl-1.2.12[joystick] )
		opengl? ( virtual/opengl )
		xv? ( x11-libs/libXv )
		xrandr? ( x11-libs/libXrandr )
		alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	gtk? ( virtual/pkgconfig
		xv? ( x11-proto/videoproto ) )
	nls? ( dev-util/intltool )"

S="${WORKDIR}/${P}/unix"

PATCHES=(
	"${FILESDIR}"/${PN}-1.54.1-build.patch
	"${FILESDIR}"/${PN}-1.53-cross-compile.patch
	"${FILESDIR}"/${PN}-1.54.1-system-zlib.patch
)

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	rm -r unzip || die
	default
	cd unix
	eautoreconf
	if use gtk; then
		cd ../gtk || die
		eautoreconf
	fi
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack

	# build breaks when zlib/zip support is disabled
	econf \
		--enable-gzip \
		--enable-zip \
		--with-system-zip \
		$(use_enable joystick gamepad) \
		$(use_enable debug debugger) \
		$(use_enable netplay) \
		$(use_enable png screenshot)

	if use gtk; then
		cd ../gtk || die
		econf \
			--datadir=/usr/share \
			--with-zlib \
			--with-system-zip \
			$(use_enable nls) \
			$(use_with opengl) \
			$(use_with joystick) \
			$(use_with xv) \
			$(use_with xrandr) \
			$(use_with netplay) \
			$(use_with alsa) \
			$(use_with oss) \
			$(use_with pulseaudio) \
			$(use_with portaudio) \
			$(use_with png screenshot)
	fi
}

src_compile() {
	emake
	if use gtk; then
		emake -C ../gtk
	fi
}

src_install() {
	dobin ${PN}

	dodoc ../docs/{snes9x.conf.default,{changes,control-inputs,controls,snapshots}.txt}

	if use gtk; then
		emake -C ../gtk DESTDIR="${D}" install
		dodoc ../gtk/{AUTHORS,doc/README}
	fi

	docinto html
	dodoc {.,..}/docs/*.html
}

pkg_preinst() {
	use gtk && gnome2_icon_savelist
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
