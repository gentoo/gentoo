# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pax-utils

DESCRIPTION="The Ubiquitous Amiga Emulator with an emulation core largely based on WinUAE"
HOMEPAGE="http://www.rcdrummond.net/uae/"
# We support _rcX for WIPX versions and _preYYYYMMDD for CVS snapshots.
if [[ "${PV%%_rc*}" = "${PV}" ]] ; then
	# _pre is used, cvs version
	my_ver=${PV%%_pre*}
	snap_ver=${PV##*_pre}
	S="${WORKDIR}"/${PN}-${my_ver}-${snap_ver}
	SRC_URI="http://www.rcdrummond.net/uae/test/${snap_ver}/${PN}-${my_ver}-${snap_ver}.tar.bz2"
else
	my_ver=${PV%%_rc*}
	WIP_ver=${PV##*_rc}
	S="${WORKDIR}"/${PN}-${my_ver}-WIP${WIP_ver}
	SRC_URI="http://www.rcdrummond.net/uae/${PN}-${my_ver}-WIP${WIP_ver}/${PN}-${my_ver}-WIP${WIP_ver}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X dga ncurses sdl alsa oss sdl-sound capslib"

# Note: opposed to ./configure --help zlib support required! Check
# src/Makefile.am that includes zfile.c unconditionaly.
RDEPEND="
	sys-libs/zlib
	virtual/cdrtools
	X? (
		x11-libs/libXt
		x11-libs/libxkbfile
		x11-libs/libXext
		x11-misc/xkeyboard-config
		dga? (
			x11-libs/libXxf86dga
			x11-libs/libXxf86vm
		)
	)
	!X? (
		sdl? ( media-libs/libsdl )
		!sdl? ( sys-libs/ncurses:0= )
	)
	alsa? ( media-libs/alsa-lib )
	!alsa? ( sdl-sound? ( media-libs/sdl-sound ) )
	capslib? ( >=games-emulation/caps-20060612 )
"

DEPEND="${RDEPEND}
	X? ( dga? ( x11-base/xorg-proto ) )
"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch #527628
	"${FILESDIR}"/${P}-no_schily.patch
)

src_prepare() {
	default
	# Fix for high cpu use when compiled with --disable-audio
	if ! use alsa && ! use sdl-sound && ! use oss ; then
		eapply "${FILESDIR}"/${P}-high-cpu-usage.patch
	fi
	eautoreconf #527628
}

src_configure() {
	strip-flags

	local myconf=()

	# Sound setup.
	if use alsa; then
		elog "Choosing alsa as sound target to use."
		myconf=( --with-alsa --without-sdl-sound )
	elif use sdl-sound ; then
		if ! use sdl ; then
			ewarn "sdl-sound is not enabled because sdl USE flag is disabled. Leaving"
			ewarn "sound on oss autodetection."
			myconf=( --without-alsa --without-sdl-sound )
		else
			elog "Choosing sdl-sound as sound target to use."
			ewarn "E-UAE with the SDL audio back-end doesn't work correctly in Linux."
			ewarn "Better use alsa... You've been warned ;)"
			myconf=( --without-alsa --with-sdl-sound )
		fi
	elif use oss ; then
		elog "Choosing oss as sound target to use."
		ewarn "oss will be autodetected. See output of configure."
		myconf=( --without-alsa --without-sdl-sound )
	else
		ewarn "There is no alsa, sdl-sound or oss in USE. Sound target disabled!"
		myconf=( --disable-audio )
	fi

	# VIDEO setup. X is autodetected (there is no --with-X option).
	if use X ; then
		elog "Using X11 for video output."
		ewarn "Fullscreen mode is not working in X11 currently. Use sdl."
		myconf+=( --without-curses --without-sdl-gfx )
		use dga && ewarn "To use dga you have to run e-uae as root."
		use dga && myconf+=( --enable-dga --enable-vidmode )
	elif use sdl ; then
		elog "Using sdl for video output."
		myconf+=( --with-sdl --with-sdl-gfx --without-curses )
	elif use ncurses; then
		elog "Using ncurses for video output."
		myconf+=( --with-curses --without-sdl-gfx )
	else
		ewarn "There is no X or sdl or ncurses in USE!"
		ewarn "Following upstream falling back on ncurses."
		myconf+=( --with-curses --without-sdl-gfx )
	fi

	# bug #415787
	myconf+=(
		--disable-ui
		$(use_with capslib caps)
		--with-zlib

		# And explicitly state defaults:
		--enable-aga

		--enable-autoconfig
		--enable-scsi-device
		--enable-cdtv
		--enable-cd32

		--enable-bsdsock

		--with-libscg-includedir="${EPREFIX}"/usr/include/scsilib
	)

	econf ${myconf[@]}
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install

	# The emulator needs to be able to create executable heap
	# - doesn't need trampoline emulation though.
	pax-mark me "${ED%/}/usr/bin/uae"

	# Rename it to e-uae
	mv "${ED%/}"/usr/bin/{,e-}uae || die
	mv "${ED%/}"/usr/bin/{,e-}readdisk || die

	dodoc docs/* README ChangeLog
}
