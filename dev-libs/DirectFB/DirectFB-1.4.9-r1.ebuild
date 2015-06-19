# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/DirectFB/DirectFB-1.4.9-r1.ebuild,v 1.8 2015/01/28 19:30:18 mgorny Exp $

EAPI=2
inherit eutils toolchain-funcs

# Map Gentoo IUSE expand vars to DirectFB drivers
# echo `sed -n '/Possible gfxdrivers are:/,/^$/{/Possible/d;s:\[ *::;s:\].*::;s:,::g;p}' configure.in`
I_TO_D_intel="i810,i830"
I_TO_D_mga="matrox"
I_TO_D_r128="ati128"
I_TO_D_s3="unichrome"
I_TO_D_sis="sis315"
I_TO_D_via="cle266"
# cyber5k davinci ep9x gl omap pxa3xx sh772x
IUSE_VIDEO_CARDS=" intel mach64 mga neomagic nsc nvidia r128 radeon s3 savage sis tdfx via vmware"
IUV=${IUSE_VIDEO_CARDS// / video_cards_}
# echo `sed -n '/Possible inputdrivers are:/,/^$/{/\(Possible\|^input\)/d;s:\[ *::;s:\].*::;s:,::g;p}' configure.in`
I_TO_D_elo2300="elo-input"
I_TO_D_evdev="linuxinput"
I_TO_D_mouse="ps2mouse serialmouse"
# dbox2remote dreamboxremote gunze h3600_ts penmount sonypijogdial ucb1x00 wm97xx zytronic
IUSE_INPUT_DEVICES=" dynapro elo2300 evdev joystick keyboard lirc mouse mutouch tslib"
IUD=${IUSE_INPUT_DEVICES// / input_devices_}

DESCRIPTION="Thin library on top of the Linux framebuffer devices"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://directfb.org/downloads/Core/${PN}-${PV:0:3}/${P}.tar.gz
	http://directfb.org/downloads/Old/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 -mips ppc ppc64 sh -sparc x86"
IUSE="debug doc fbcon gif jpeg cpu_flags_x86_mmx png sdl cpu_flags_x86_sse static-libs truetype v4l X zlib ${IUV} ${IUD}"

RDEPEND="sdl? ( media-libs/libsdl )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	zlib? ( sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2.0.1 )
	X? ( x11-libs/libXext x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto x11-proto/xproto )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.2.7-CFLAGS.patch \
		"${FILESDIR}"/${PN}-1.2.0-headers.patch \
		"${FILESDIR}"/${PN}-1.1.1-pkgconfig.patch \
		"${FILESDIR}"/${PN}-1.4.9-libpng-1.5.patch

	# the media subdir uses sqrt(), so make sure it links in -lm
	sed -i \
		-e '/libdirectfb_media_la_LIBADD/s:$: -lm:' \
		src/media/Makefile.in || die

	# Avoid invoking `ld` directly #300779
	find . -name Makefile.in -exec sed -i \
		'/[$](LD)/s:$(LD) -o $@ -r:$(CC) $(LDFLAGS) $(CFLAGS) -Wl,-r -nostdlib -o $@:' {} +
}

driver_list() {
	local pfx=$1
	local dev devs map
	shift
	for dev in "$@" ; do
		use ${pfx}_${dev} || continue
		map="I_TO_D_${dev}"
		devs=${devs:+${devs},}${!map:-${dev}}
	done
	echo ${devs:-none}
}

src_configure() {
	local sdlconf="--disable-sdl"
	if use sdl ; then
		# since SDL can link against DirectFB and trigger a
		# dependency loop, only link against SDL if it isn't
		# broken #61592
		echo 'int main(){}' > sdl-test.c
		$(tc-getCC) sdl-test.c -lSDL 2>/dev/null \
			&& sdlconf="--enable-sdl" \
			|| ewarn "Disabling SDL since libSDL.so is broken"
	fi

	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable X x11) \
		$(use_enable fbcon fbdev) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable gif) \
		$(use_enable truetype freetype) \
		$(use_enable debug) \
		$(use_enable zlib) \
		--disable-video4linux \
		$(use_enable v4l video4linux2) \
		${sdlconf} \
		--with-gfxdrivers="$(driver_list video_cards ${IUSE_VIDEO_CARDS})" \
		--with-inputdrivers="$(driver_list input_devices ${IUSE_INPUT_DEVICES})" \
		--disable-vnc
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc fb.modes AUTHORS ChangeLog NEWS README* TODO
	use doc && dohtml -r docs/html/*
}

pkg_postinst() {
	ewarn "Each DirectFB update breaks DirectFB related applications."
	ewarn "Please run \"revdep-rebuild\" which can be"
	ewarn "found by emerging the package 'gentoolkit'."
	ewarn
	ewarn "If you have an ALPS touchpad, then you might get your mouse"
	ewarn "unexpectedly set in absolute mode in all DirectFB applications."
	ewarn "This can be fixed by removing linuxinput from INPUT_DEVICES."
}
