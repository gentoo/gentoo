# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic pax-utils

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
RDEPEND="X? ( x11-libs/libXt
			 x11-libs/libxkbfile
			 x11-libs/libXext
			 x11-misc/xkeyboard-config
			 dga? ( x11-libs/libXxf86dga
				    x11-libs/libXxf86vm )
			)
		!X? ( sdl? ( media-libs/libsdl )
			  !sdl? ( sys-libs/ncurses ) )
		alsa? ( media-libs/alsa-lib )
		!alsa? ( sdl-sound? ( media-libs/sdl-sound ) )
		capslib? ( >=games-emulation/caps-20060612 )
		sys-libs/zlib
		virtual/cdrtools"

DEPEND="${RDEPEND}
		X? ( dga? ( x11-proto/xf86vidmodeproto
					x11-proto/xf86dgaproto ) )"

src_prepare() {
	# Fix for high cpu use when compiled with --disable-audio
	use alsa || use sdl-sound || use oss || epatch "${FILESDIR}"/${P}-high-cpu-usage.patch
}

src_configure() {
	strip-flags

	local myconf

	# Sound setup.
	if use alsa; then
		elog "Choosing alsa as sound target to use."
		myconf="--with-alsa --without-sdl-sound"
	elif use sdl-sound ; then
		if ! use sdl ; then
			ewarn "sdl-sound is not enabled because sdl USE flag is disabled. Leaving"
			ewarn "sound on oss autodetection."
			myconf="--without-alsa --without-sdl-sound"
			ebeep
		else
			elog "Choosing sdl-sound as sound target to use."
			ewarn "E-UAE with the SDL audio back-end doesn't work correctly in Linux."
			ewarn "Better use alsa... You've been warned ;)"
			ebeep
			myconf="--without-alsa --with-sdl-sound"
		fi
	elif use oss ; then
		elog "Choosing oss as sound target to use."
		ewarn "oss will be autodetected. See output of configure."
		myconf="--without-alsa --without-sdl-sound"
	else
		ewarn "There is no alsa, sdl-sound or oss in USE. Sound target disabled!"
		myconf="--disable-audio"
	fi

	# VIDEO setup. X is autodetected (there is no --with-X option).
	if use X ; then
		elog "Using X11 for video output."
		ewarn "Fullscreen mode is not working in X11 currently. Use sdl."
		myconf="$myconf --without-curses --without-sdl-gfx"
		use dga && ewarn "To use dga you have to run e-uae as root."
		use dga && myconf="$myconf --enable-dga --enable-vidmode"
	elif use sdl ; then
		elog "Using sdl for video output."
		myconf="$myconf --with-sdl --with-sdl-gfx --without-curses"
	elif use ncurses; then
		elog "Using ncurses for video output."
		myconf="$myconf --with-curses --without-sdl-gfx"
	else
		ewarn "There is no X or sdl or ncurses in USE!"
		ewarn "Following upstream falling back on ncurses."
		myconf="$myconf --with-curses --without-sdl-gfx"
		ebeep
	fi

	# bug #415787
	myconf="$myconf --disable-ui"

	myconf="$myconf $(use_with capslib caps)"

	myconf="$myconf --with-zlib"

	# And explicitly state defaults:
	myconf="$myconf --enable-aga"
	myconf="$myconf --enable-autoconfig --enable-scsi-device --enable-cdtv --enable-cd32"
	myconf="$myconf --enable-bsdsock"

	econf ${myconf} \
		--with-libscg-includedir="${EPREFIX}"/usr/include/scsilib \
		|| die "./configure failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# The emulator needs to be able to create executable heap
	# - doesn't need trampoline emulation though.
	pax-mark me "${ED}/usr/bin/uae"

	# Rename it to e-uae
	mv "${ED}/usr/bin/uae" "${ED}/usr/bin/e-uae"
	mv "${ED}/usr/bin/readdisk" "${ED}/usr/bin/e-readdisk"

	dodoc docs/* README ChangeLog
}
