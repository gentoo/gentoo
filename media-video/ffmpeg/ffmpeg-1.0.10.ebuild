# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-1.0.10.ebuild,v 1.5 2015/03/05 14:00:41 aballier Exp $

EAPI="4"

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://source.ffmpeg.org/ffmpeg.git"
fi

inherit eutils flag-o-matic multilib toolchain-funcs ${SCM}

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
SLOT="0"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi
IUSE="
	aac aacplus alsa amr bluray +bzip2 cdio celt
	cpudetection debug doc +encode examples faac fdk flite fontconfig frei0r
	gnutls gsm +hardcoded-tables iec61883 ieee1394 jack jpeg2k libass libcaca
	libv4l modplug mp3 +network openal openssl opus oss pic pulseaudio rtmp
	schroedinger sdl speex static-libs test theora threads truetype twolame v4l
	vaapi vdpau vorbis vpx X x264 xvid +zlib
	"

# String for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
CPU_FEATURES="cpu_flags_x86_3dnow:amd3dnow cpu_flags_x86_3dnowext:amd3dnowext altivec cpu_flags_x86_avx:avx cpu_flags_x86_mmx:mmx cpu_flags_x86_mmxext:mmxext cpu_flags_x86_ssse3:ssse3 vis neon"

for i in ${CPU_FEATURES}; do
	IUSE="${IUSE} ${i%:*}"
done

FFTOOLS="aviocat cws2fws ffeval fourcc2pixfmt graph2dot ismindex pktdumper qt-faststart trasher"

for i in ${FFTOOLS}; do
	IUSE="${IUSE} +fftools_$i"
done

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	bluray? ( media-libs/libbluray )
	bzip2? ( app-arch/bzip2 )
	cdio? ( dev-libs/libcdio-paranoia )
	celt? ( >=media-libs/celt-0.11.1 )
	encode? (
		aac? ( media-libs/vo-aacenc )
		aacplus? ( media-libs/libaacplus )
		amr? ( media-libs/vo-amrwbenc )
		faac? ( media-libs/faac )
		fdk? ( media-libs/fdk-aac )
		mp3? ( >=media-sound/lame-3.98.3 )
		theora? ( >=media-libs/libtheora-1.1.1[encode] media-libs/libogg )
		twolame? ( media-sound/twolame )
		x264? ( >=media-libs/x264-0.0.20111017 )
		xvid? ( >=media-libs/xvid-1.1.0 )
	)
	flite? ( app-accessibility/flite )
	fontconfig? ( media-libs/fontconfig )
	frei0r? ( media-plugins/frei0r-plugins )
	gnutls? ( >=net-libs/gnutls-2.12.16 )
	gsm? ( >=media-sound/gsm-1.0.12-r1 )
	iec61883? ( media-libs/libiec61883 sys-libs/libraw1394 sys-libs/libavc1394 )
	ieee1394? ( media-libs/libdc1394 sys-libs/libraw1394 )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg2k? ( >=media-libs/openjpeg-1.3-r2:0 )
	libass? ( media-libs/libass )
	libcaca? ( media-libs/libcaca )
	libv4l? ( media-libs/libv4l )
	modplug? ( media-libs/libmodplug )
	openal? ( >=media-libs/openal-1.1 )
	openssl? ( dev-libs/openssl )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	rtmp? ( >=media-video/rtmpdump-2.2f )
	sdl? ( >=media-libs/libsdl-1.2.13-r1[sound,video] )
	schroedinger? ( media-libs/schroedinger )
	speex? ( >=media-libs/speex-1.2_beta3 )
	truetype? ( media-libs/freetype:2 )
	vaapi? ( >=x11-libs/libva-0.32 )
	vdpau? ( x11-libs/libvdpau )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	vpx? ( >=media-libs/libvpx-0.9.6 )
	X? ( x11-libs/libX11 x11-libs/libXext x11-libs/libXfixes )
	zlib? ( sys-libs/zlib )
	!media-video/qt-faststart
	!media-libs/libpostproc
"

DEPEND="${RDEPEND}
	>=sys-devel/make-3.81
	doc? ( app-text/texi2html )
	fontconfig? ( virtual/pkgconfig )
	gnutls? ( virtual/pkgconfig )
	ieee1394? ( virtual/pkgconfig )
	libv4l? ( virtual/pkgconfig )
	cpu_flags_x86_mmx? ( dev-lang/yasm )
	rtmp? ( virtual/pkgconfig )
	schroedinger? ( virtual/pkgconfig )
	test? ( net-misc/wget )
	truetype? ( virtual/pkgconfig )
	v4l? ( sys-kernel/linux-headers )
"
REQUIRED_USE="
	libv4l? ( v4l )
	fftools_cws2fws? ( zlib )
	test? ( encode )"
# faac is license-incompatible with ffmpeg
RESTRICT="encode? ( faac? ( bindist ) aacplus? ( bindist ) ) openssl? ( bindist )"

S=${WORKDIR}/${P/_/-}

src_prepare() {
	if [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi

	sed -i \
		-e 's:cdio/cdda.h:cdio/paranoia/cdda.h:' \
		-e 's:cdio/paranoia.h:cdio/paranoia/paranoia.h:' \
		configure libavdevice/libcdio.c || die

	epatch "${FILESDIR}"/${PN}-1.0.8-freetype251.patch
}

src_configure() {
	local myconf="${EXTRA_FFMPEG_CONF}"
	# Set to --enable-version3 if (L)GPL-3 is required
	local version3=""

	# enabled by default
	for i in debug doc network vaapi vdpau zlib; do
		use ${i} || myconf="${myconf} --disable-${i}"
	done
	use bzip2 || myconf="${myconf} --disable-bzlib"
	use sdl || myconf="${myconf} --disable-ffplay"

	use cpudetection || myconf="${myconf} --disable-runtime-cpudetect"
	use openssl && myconf="${myconf} --enable-openssl --enable-nonfree"
	for i in gnutls ; do
		use $i && myconf="${myconf} --enable-$i"
	done

	# Encoders
	if use encode
	then
		use mp3 && myconf="${myconf} --enable-libmp3lame"
		use aac && { myconf="${myconf} --enable-libvo-aacenc" ; version3=" --enable-version3" ; }
		use amr && { myconf="${myconf} --enable-libvo-amrwbenc" ; version3=" --enable-version3" ; }
		for i in theora twolame x264 xvid; do
			use ${i} && myconf="${myconf} --enable-lib${i}"
		done
		use aacplus && myconf="${myconf} --enable-libaacplus --enable-nonfree"
		use faac && myconf="${myconf} --enable-libfaac --enable-nonfree"
		use fdk && myconf="${myconf} --enable-libfdk-aac --enable-nonfree"
	else
		myconf="${myconf} --disable-encoders"
	fi

	# libavdevice options
	for i in cdio iec61883 ; do
		use ${i} && myconf="${myconf} --enable-lib${i}"
	done
	use ieee1394 && myconf="${myconf} --enable-libdc1394"
	use libcaca && myconf="${myconf} --enable-libcaca"
	use openal && myconf="${myconf} --enable-openal"
	# Indevs
	use v4l || myconf="${myconf} --disable-indev=v4l2"
	for i in alsa oss jack ; do
		use ${i} || myconf="${myconf} --disable-indev=${i}"
	done
	use X && myconf="${myconf} --enable-x11grab"
	use pulseaudio && myconf="${myconf} --enable-libpulse"
	use libv4l && myconf="${myconf} --enable-libv4l2"
	# Outdevs
	for i in alsa oss sdl ; do
		use ${i} || myconf="${myconf} --disable-outdev=${i}"
	done
	# libavfilter options
	for i in frei0r fontconfig libass ; do
		use ${i} && myconf="${myconf} --enable-${i}"
	done
	use truetype && myconf="${myconf} --enable-libfreetype"
	use flite    && myconf="${myconf} --enable-libflite"

	# Threads; we only support pthread for now but ffmpeg supports more
	use threads && myconf="${myconf} --enable-pthreads"

	# Decoders
	use amr && { myconf="${myconf} --enable-libopencore-amrwb --enable-libopencore-amrnb" ; version3=" --enable-version3" ; }
	for i in bluray celt gsm modplug opus rtmp schroedinger speex vorbis vpx; do
		use ${i} && myconf="${myconf} --enable-lib${i}"
	done
	use jpeg2k && myconf="${myconf} --enable-libopenjpeg"

	# CPU features
	for i in ${CPU_FEATURES}; do
		use ${i%:*} || myconf="${myconf} --disable-${i#*:}"
	done
	if use pic ; then
		myconf="${myconf} --enable-pic"
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		use x86 && myconf="${myconf} --disable-asm"
	fi
	[[ ${ABI} == "x32" ]] && myconf+=" --disable-asm" #427004

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[ "${i}" = "native" ] && i="host" # bug #273421
		myconf="${myconf} --cpu=${i}"
		break
	done

	# Mandatory configuration
	myconf="
		--enable-gpl
		${version3}
		--enable-postproc
		--enable-avfilter
		--enable-avresample
		--disable-stripping
		${myconf}"

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf="${myconf} --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}-"
		case ${CHOST} in
			*freebsd*)
				myconf="${myconf} --target-os=freebsd"
				;;
			mingw32*)
				myconf="${myconf} --target-os=mingw32"
				;;
			*linux*)
				myconf="${myconf} --target-os=linux"
				;;
		esac
	fi

	# Misc stuff
	use hardcoded-tables && myconf="${myconf} --enable-hardcoded-tables"

	cd "${S}"
	./configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--mandir="${EPREFIX}/usr/share/man" \
		--enable-shared \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--optflags="${CFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		$(use_enable static-libs static) \
		${myconf} || die
}

src_compile() {
	emake V=1

	for i in ${FFTOOLS} ; do
		if use fftools_$i ; then
			emake V=1 tools/$i
		fi
	done
}

src_install() {
	emake V=1 DESTDIR="${D}" install install-man

	dodoc Changelog README CREDITS doc/*.txt doc/APIchanges doc/RELEASE_NOTES
	use doc && dohtml -r doc/*
	if use examples ; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r doc/examples/*
	fi

	for i in ${FFTOOLS} ; do
		if use fftools_$i ; then
			dobin tools/$i
		fi
	done
}

src_test() {
	LD_LIBRARY_PATH="${S}/libpostproc:${S}/libswscale:${S}/libswresample:${S}/libavcodec:${S}/libavdevice:${S}/libavfilter:${S}/libavformat:${S}/libavutil:${S}/libavresample" \
		emake V=1 fate
}
