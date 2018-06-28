# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic gnome2-utils xdg-utils

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="https://github.com/snes9xgit/snes9x"
SRC_URI="https://github.com/snes9xgit/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd"
IUSE="alsa debug gtk joystick multilib netplay nls opengl oss png pulseaudio portaudio xinerama +xv"
RESTRICT="bindist"

RDEPEND="
	sys-libs/zlib:=[minizip]
	x11-libs/libX11
	x11-libs/libXext
	png? ( media-libs/libpng:0= )
	gtk? (
		dev-libs/glib:2
		dev-libs/libxml2
		>=x11-libs/gtk+-3.0:3
		x11-libs/libXrandr
		x11-misc/xdg-utils
		alsa? ( media-libs/alsa-lib )
		joystick? ( media-libs/libsdl2[joystick] )
		opengl? (
			media-libs/libepoxy
			virtual/opengl
		)
		portaudio? ( >=media-libs/portaudio-19_pre )
		pulseaudio? ( media-sound/pulseaudio )
		xv? ( x11-libs/libXv )
	)
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	nls? ( dev-util/intltool )"

S="${WORKDIR}/${P}/unix"

PATCHES=(
	"${FILESDIR}"/${PN}-1.53-cross-compile.patch
	"${FILESDIR}"/${PN}-1.56-build-system.patch
)

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	rm -r unzip || die
	default
	cd unix || die
	eautoreconf
	if use gtk; then
		cd ../gtk || die
		eautoreconf
	fi
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack

	# build breaks when zlib/zip support is disabled
	local myeconfargs=(
		--enable-gzip
		--enable-zip
		--with-system-zip
		$(use_enable joystick gamepad)
		$(use_enable debug debugger)
		$(use_enable netplay)
		$(use_enable png screenshot)
		$(use_enable xinerama)
	)
	econf "${myeconfargs[@]}"

	if use gtk; then
		cd ../gtk || die
		myeconfargs=(
			--with-gtk3
			--with-zlib
			--with-system-zip
			--without-gtk2
			$(use_enable nls)
			$(use_with opengl)
			$(use_with joystick)
			$(use_with xv)
			$(use_with netplay)
			$(use_with alsa)
			$(use_with oss)
			$(use_with pulseaudio)
			$(use_with portaudio)
			$(use_with png screenshot)
		)
		econf "${myeconfargs[@]}"
	fi
}

src_compile() {
	emake
	use gtk && emake -C ../gtk
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
	if use gtk ; then
		gnome2_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use gtk ; then
		gnome2_icon_cache_update
		xdg_desktop_database_update
	fi
}
