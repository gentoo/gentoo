# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-2.2.14.ebuild,v 1.10 2015/05/30 10:55:14 maekke Exp $

EAPI="5"

# Subslot: libavutil major.libavcodec major.libavformat major
# Since FFmpeg ships several libraries, subslot is kind of limited here.
# Most consumers will use those three libraries, if a "less used" library
# changes its soname, consumers will have to be rebuilt the old way
# (preserve-libs).
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
FFMPEG_SUBSLOT=52.55.55

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://source.ffmpeg.org/ffmpeg.git"
fi

inherit eutils flag-o-matic multilib multilib-minimal toolchain-funcs ${SCM}

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec"
HOMEPAGE="http://ffmpeg.org/"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
elif [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
else # Release
	SRC_URI="http://ffmpeg.org/releases/${P/_/-}.tar.bz2"
fi
FFMPEG_REVISION="${PV#*_p}"

LICENSE="GPL-2 amr? ( GPL-3 ) encode? ( aac? ( GPL-3 ) )"
SLOT="0/${FFMPEG_SUBSLOT}"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi
IUSE="
	aac aacplus alsa amr amrenc bluray +bzip2 cdio celt
	cpudetection debug doc +encode examples faac fdk flite fontconfig frei0r
	gme	gnutls gsm +hardcoded-tables +iconv iec61883 ieee1394 jack jpeg2k
	ladspa libass libcaca libsoxr libv4l modplug mp3 +network openal opengl
	openssl opus oss pic pulseaudio quvi rtmp schroedinger sdl speex ssh
	static-libs test theora threads truetype twolame v4l vaapi vdpau vorbis vpx
	wavpack webp X x264 x265 xvid +zlib zvbi
	"

ARM_CPU_FEATURES="armv5te armv6 armv6t2 neon armvfp:vfp"
MIPS_CPU_FEATURES="mips32r2 mipsdspr1 mipsdspr2 mipsfpu"
PPC_CPU_FEATURES="altivec"
X86_CPU_FEATURES=( 3dnow:amd3dnow 3dnowext:amd3dnowext avx:avx avx2:avx2 fma3:fma3 fma4:fma4 mmx:mmx mmxext:mmxext sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4 sse4_2:sse42 )

# String for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
CPU_FEATURES="
	${ARM_CPU_FEATURES}
	${MIPS_CPU_FEATURES}
	${PPC_CPU_FEATURES}
	${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}
"

for i in ${CPU_FEATURES}; do
	IUSE="${IUSE} ${i%:*}"
done

FFTOOLS="aviocat cws2fws ffescape ffeval ffhash fourcc2pixfmt graph2dot ismindex pktdumper qt-faststart trasher"

for i in ${FFTOOLS}; do
	IUSE="${IUSE} +fftools_$i"
done

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	amr? ( >=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}] )
	bluray? ( >=media-libs/libbluray-0.3.0-r1[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	cdio? ( >=dev-libs/libcdio-paranoia-0.90_p1-r1[${MULTILIB_USEDEP}] )
	celt? ( >=media-libs/celt-0.11.1-r1[${MULTILIB_USEDEP}] )
	encode? (
		aac? ( >=media-libs/vo-aacenc-0.1.3[${MULTILIB_USEDEP}] )
		aacplus? ( >=media-libs/libaacplus-2.0.2-r1[${MULTILIB_USEDEP}] )
		amrenc? ( >=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}] )
		faac? ( >=media-libs/faac-1.28-r3[${MULTILIB_USEDEP}] )
		mp3? ( >=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}] )
		theora? (
			>=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}]
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
		)
		twolame? ( >=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}] )
		wavpack? ( >=media-sound/wavpack-4.60.1-r1[${MULTILIB_USEDEP}] )
		webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )
		x264? ( >=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}] )
		x265? ( >=media-libs/x265-0.8:=[${MULTILIB_USEDEP}] )
		xvid? ( >=media-libs/xvid-1.3.2-r1[${MULTILIB_USEDEP}] )
	)
	fdk? ( >=media-libs/fdk-aac-0.1.3[${MULTILIB_USEDEP}] )
	flite? ( >=app-accessibility/flite-1.4-r4[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	frei0r? ( media-plugins/frei0r-plugins )
	gme? ( >=media-libs/game-music-emu-0.6.0[${MULTILIB_USEDEP}] )
	gnutls? ( >=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}] )
	gsm? ( >=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	iec61883? (
		>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		>=media-libs/libdc1394-2.2.1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	jack? ( >=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-1.5.0:0[${MULTILIB_USEDEP}] )
	libass? ( >=media-libs/libass-0.10.2[${MULTILIB_USEDEP}] )
	libcaca? ( >=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}] )
	libsoxr? ( >=media-libs/soxr-0.1.0[${MULTILIB_USEDEP}] )
	libv4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	openssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	opus? ( >=media-libs/opus-1.0.2-r2[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	quvi? ( media-libs/libquvi:0.4 )
	rtmp? ( >=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}] )
	sdl? ( >=media-libs/libsdl-1.2.15-r4[sound,video,${MULTILIB_USEDEP}] )
	schroedinger? ( >=media-libs/schroedinger-1.0.11-r1[${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh-0.5.5[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	vaapi? ( >=x11-libs/libva-1.2.1-r1[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}] )
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vpx? ( >=media-libs/libvpx-1.2.0_pre20130625[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zvbi? ( >=media-libs/zvbi-0.2.35[${MULTILIB_USEDEP}] )
	!media-video/qt-faststart
	!media-libs/libpostproc
"

DEPEND="${RDEPEND}
	>=sys-devel/make-3.81
	doc? ( app-text/texi2html )
	fontconfig? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	gnutls? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	ieee1394? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	ladspa? ( >=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}] )
	libv4l? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	cpu_flags_x86_mmx? ( >=dev-lang/yasm-1.2 )
	rtmp? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	schroedinger? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	test? ( net-misc/wget sys-devel/bc )
	truetype? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	v4l? ( sys-kernel/linux-headers )
"

RDEPEND="${RDEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20140508-r3
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

REQUIRED_USE="
	libv4l? ( v4l )
	fftools_cws2fws? ( zlib )
	test? ( encode )"
# faac is license-incompatible with ffmpeg
RESTRICT="encode? ( faac? ( bindist ) aacplus? ( bindist ) ) openssl? ( bindist )"

S=${WORKDIR}/${P/_/-}

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libavutil/avconfig.h
)

src_prepare() {
	if [[ "${PV%_p*}" != "${PV}" ]] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi
	epatch "${FILESDIR}/ladspadl.patch"
	epatch_user
}

multilib_src_configure() {
	local myconf=( ${EXTRA_FFMPEG_CONF} )

	# options to use as use_enable in the foo[:bar] form.
	# This will feed configure with $(use_enable foo bar)
	# or $(use_enable foo foo) if no :bar is set.
	local ffuse=(
		bzip2:bzlib cpudetection:runtime-cpudetect debug doc
		gnutls hardcoded-tables iconv network openssl sdl:ffplay vaapi
		vdpau zlib
	)
	use openssl && myconf+=( --enable-nonfree )

	# Encoders
	if use encode
	then
		ffuse+=( aac:libvo-aacenc amrenc:libvo-amrwbenc mp3:libmp3lame )
		for i in aacplus faac theora twolame wavpack webp x264 x265 xvid; do
			ffuse+=( ${i}:lib${i} )
		done

		# Licensing.
		if use aac || use amrenc ; then
			myconf+=( --enable-version3 )
		fi
		if use aacplus || use faac ; then
			myconf+=( --enable-nonfree )
		fi
	else
		myconf+=( --disable-encoders )
	fi

	# libavdevice options
	ffuse+=( cdio:libcdio iec61883:libiec61883 ieee1394:libdc1394 libcaca openal opengl )

	# Indevs
	use v4l || myconf+=( --disable-indev=v4l2 --disable-outdev=v4l2 )
	for i in alsa oss jack ; do
		use ${i} || myconf+=( --disable-indev=${i} )
	done
	ffuse+=( libv4l:libv4l2 pulseaudio:libpulse X:x11grab )

	# Outdevs
	for i in alsa oss sdl ; do
		use ${i} || myconf+=( --disable-outdev=${i} )
	done

	# libavfilter options
	ffuse+=( flite:libflite frei0r fontconfig ladspa libass truetype:libfreetype )

	# libswresample options
	ffuse+=( libsoxr )

	# Threads; we only support pthread for now but ffmpeg supports more
	ffuse+=( threads:pthreads )

	# Decoders
	ffuse+=( amr:libopencore-amrwb amr:libopencore-amrnb fdk:libfdk-aac jpeg2k:libopenjpeg )
	use amr && myconf+=( --enable-version3 )
	for i in bluray celt gme gsm modplug opus quvi rtmp ssh schroedinger speex vorbis vpx zvbi; do
		ffuse+=( ${i}:lib${i} )
	done
	use fdk && myconf+=( --enable-nonfree )

	for i in "${ffuse[@]}" ; do
		myconf+=( $(use_enable ${i%:*} ${i#*:}) )
	done

	# (temporarily) disable non-multilib deps
	if ! multilib_is_native_abi; then
		for i in frei0r libquvi; do
			myconf+=( --disable-${i} )
		done
	fi

	# CPU features
	for i in ${CPU_FEATURES}; do
		use ${i%:*} || myconf+=( --disable-${i#*:} )
	done
	if use pic ; then
		myconf+=( --enable-pic )
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		[[ ${ABI} == x86 ]] && myconf+=( --disable-asm )
	fi
	[[ ${ABI} == x32 ]] && myconf+=( --disable-asm ) #427004

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag mcpu) $(get-flag mtune) $(get-flag march) ; do
		[[ ${i} = native ]] && i="host" # bug #273421
		myconf+=( --cpu=${i} )
		break
	done

	# Mandatory configuration
	myconf=(
		--enable-gpl
		--enable-postproc
		--enable-avfilter
		--enable-avresample
		--disable-stripping
		"${myconf[@]}"
	)

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf+=( --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}- )
		case ${CHOST} in
			*freebsd*)
				myconf+=( --target-os=freebsd )
				;;
			mingw32*)
				myconf+=( --target-os=mingw32 )
				;;
			*linux*)
				myconf+=( --target-os=linux )
				;;
		esac
	fi

	set -- "${S}/configure" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--mandir="${EPREFIX}/usr/share/man" \
		--enable-shared \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--optflags=" " \
		$(use_enable static-libs static) \
		"${myconf[@]}"
	echo "${@}"
	"${@}" || die
}

multilib_src_compile() {
	emake V=1

	if multilib_is_native_abi; then
		for i in ${FFTOOLS} ; do
			if use fftools_${i} ; then
				emake V=1 tools/${i}
			fi
		done
	fi
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install install-man

	if multilib_is_native_abi; then
		for i in ${FFTOOLS} ; do
			if use fftools_${i} ; then
				dobin tools/${i}
			fi
		done
	fi
}

multilib_src_install_all() {
	dodoc Changelog README CREDITS doc/*.txt doc/APIchanges doc/RELEASE_NOTES
	use doc && dohtml -r doc/*
	if use examples ; then
		dodoc -r doc/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}/libpostproc:${BUILD_DIR}/libswscale:${BUILD_DIR}/libswresample:${BUILD_DIR}/libavcodec:${BUILD_DIR}/libavdevice:${BUILD_DIR}/libavfilter:${BUILD_DIR}/libavformat:${BUILD_DIR}/libavutil:${BUILD_DIR}/libavresample" \
		emake V=1 fate
}
