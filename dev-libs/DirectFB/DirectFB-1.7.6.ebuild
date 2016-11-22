# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs

# Map Gentoo IUSE expand vars to DirectFB drivers
# echo `sed -n '/Possible gfxdrivers are:/,/^$/{/Possible/d;s:\[ *::;s:\].*::;s:,::g;p}' configure.in`
I_TO_D_intel="i810,i830"
I_TO_D_mga="matrox"
I_TO_D_r128="ati128"
I_TO_D_s3="unichrome"
I_TO_D_sis="sis315"
I_TO_D_via="cle266"
# cyber5k davinci ep9x omap pxa3xx sh772x savage pvr2d
IUSE_VIDEO_CARDS=" intel mach64 mga neomagic nsc nvidia r128 radeon s3 sis tdfx via vmware"
IUV=${IUSE_VIDEO_CARDS// / video_cards_}
# echo `sed -n '/Possible inputdrivers are:/,/^$/{/\(Possible\|^input\)/d;s:\[ *::;s:\].*::;s:,::g;p}' configure.in`
I_TO_D_elo2300="elo-input"
I_TO_D_evdev="linuxinput"
I_TO_D_mouse="ps2mouse,serialmouse"
# dbox2remote dreamboxremote gunze h3600_ts penmount sonypijogdial ucb1x00 wm97xx zytronic
IUSE_INPUT_DEVICES=" dynapro elo2300 evdev joystick keyboard lirc mouse mutouch tslib"
IUD=${IUSE_INPUT_DEVICES// / input_devices_}

DESCRIPTION="Thin library on top of the Linux framebuffer devices"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://directfb.org/downloads/Core/${PN}-${PV:0:3}/${P}.tar.gz
	http://directfb.org/downloads/Old/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 -mips ~ppc ~ppc64 ~sh -sparc ~x86"
IUSE="alsa bmp cddb debug divine drmkms +dynload doc egl fbcon fusiondale fusionsound gif gles2 gstreamer imlib2 input_hub jpeg jpeg2k mad cpu_flags_x86_mmx mng mpeg2 mpeg3 multicore opengl oss png pnm sawman sdl cpu_flags_x86_sse static-libs swfdec tiff timidity tremor truetype v4l vdpau vorbis webp X xine zlib ${IUV} ${IUD}"
REQUIRED_USE="gles2? ( opengl )"

# ffmpeg useflag broken
# ffmpeg? ( virtual/ffmpeg )
#	$(use_enable ffmpeg) \
RDEPEND="
	alsa? ( media-libs/alsa-lib )
	cddb? ( media-libs/libcddb )
	drmkms? ( x11-libs/libdrm[libkms] )
	gif? ( media-libs/giflib )
	gstreamer? ( media-libs/gstreamer:1.0 media-libs/gst-plugins-base:1.0 )
	imlib2? ( media-libs/imlib2 )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/jasper:=[jpeg] )
	mad? ( media-libs/libmad )
	mng? ( media-libs/libmng )
	mpeg3? ( media-libs/libmpeg3 )
	opengl? ( media-libs/mesa[gbm,egl?,gles2?] x11-libs/libdrm )
	png? ( media-libs/libpng:0= )
	sdl? ( media-libs/libsdl )
	tiff? ( media-libs/tiff:0 )
	timidity? (
		media-libs/libtimidity
		media-sound/timidity++
	)
	tremor? ( media-libs/tremor )
	truetype? ( >=media-libs/freetype-2.0.1 )
	vdpau? ( x11-proto/xproto x11-libs/libX11 x11-libs/libXext x11-libs/libvdpau )
	vorbis? ( media-libs/libvorbis )
	webp? ( media-libs/libwebp )
	X? ( x11-libs/libXext x11-libs/libX11 )
	xine? ( media-libs/xine-lib[vdpau?] )
	zlib? ( sys-libs/zlib )	"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto x11-proto/xproto )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.7.5-flags.patch \
		"${FILESDIR}"/${PN}-1.6.3-pkgconfig.patch \
		"${FILESDIR}"/${PN}-1.7.1-build.patch \
		"${FILESDIR}"/${PN}-1.6.3-setregion.patch \
		"${FILESDIR}"/${PN}-1.6.3-atomic-fix-compiler-error-when-building-for-thumb2.patch \
		"${FILESDIR}"/${PN}-1.7.6-cle266.patch \
		"${FILESDIR}"/${PN}-1.7.6-idivine.patch
	sed -i \
		-e '/#define RASPBERRY_PI/d' \
		systems/egl/egl_system.c || die #497124
	sed -i \
		-e '/^CXXFLAGS=.*-Werror-implicit-function-declaration/d' \
		configure.in || die #526196

	mv configure.{in,ac} || die
	eautoreconf
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
	local myaudio="wave"
	use alsa && myaudio+=",alsa"
	use oss && myaudio+=",oss"

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

	# fix --with-gfxdrivers= logic, because opengl, vdpau and gles2 are no video_cards
	local gfxdrivers="$(driver_list video_cards ${IUSE_VIDEO_CARDS})"
	use opengl && gfxdrivers="${gfxdrivers},gl"
	use vdpau && gfxdrivers="${gfxdrivers},vdpau"
	use gles2 && gfxdrivers="${gfxdrivers},gles2"
	gfxdrivers="$(echo ${gfxdrivers} | sed 's/none,//')"

	# fix --with-inputdrivers= logic, don't know where to put "input_hub"
	local inputdrivers="$(driver_list input_devices ${IUSE_INPUT_DEVICES})"
	use input_hub && inputdrivers="${inputdrivers},input_hub"
	inputdrivers="$(echo ${inputdrivers} | sed 's/none,//')"

	# The xine-vdpau flag requires a custom patch to xine-lib which we don't carry:
	# http://git.directfb.org/?p=extras/DirectFB-extra.git;a=blob;f=interfaces/IDirectFBVideoProvider/xine-lib-1.2-vdpau-hooks.patch;hb=HEAD
	econf \
		$(use_enable static-libs static) \
		$(use_enable X x11) \
		$(use_enable divine) \
		$(use_enable sawman) \
		$(use_enable fusiondale) \
		$(use_enable fusionsound) \
		$(use_enable fbcon fbdev) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable egl) \
		$(use_enable egl idirectfbgl-egl) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable mng) \
		$(use_enable gstreamer) \
		$(use_enable gif) \
		$(use_enable tiff) \
		$(use_enable imlib2) \
		$(use_enable pnm) \
		--disable-svg \
		$(use_enable mpeg2) \
		$(use_enable mpeg3 libmpeg3) \
		--disable-flash \
		$(use_enable xine) \
		--disable-xine-vdpau \
		--disable-ffmpeg \
		$(use_enable bmp) \
		$(use_enable jpeg2k jpeg2000) \
		--disable-openquicktime \
		--disable-avifile \
		$(use_enable truetype freetype) \
		$(use_enable webp) \
		$(use_enable debug) \
		$(use_enable zlib) \
		--disable-video4linux \
		$(use_enable v4l video4linux2) \
		$(use_enable vdpau x11vdpau) \
		$(use_enable multicore) \
		$(use_enable dynload) \
		$(use_enable opengl mesa) \
		$(use_enable drmkms) \
		--with-fs-drivers="${myaudio}" \
		$(use_with timidity) \
		--with-wave \
		$(use_with vorbis) \
		$(use_with tremor) \
		$(use_with mad) \
		$(use_with cddb cdda) \
		--with-playlist \
		${sdlconf} \
		--with-gfxdrivers="${gfxdrivers}" \
		--with-inputdrivers="${inputdrivers}" \
		--disable-vnc
}

src_install() {
	default
	dodoc fb.modes
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
