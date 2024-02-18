# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Subslot: libavutil major.libavcodec major.libavformat major
# Since FFmpeg ships several libraries, subslot is kind of limited here.
# Most consumers will use those three libraries, if a "less used" library
# changes its soname, consumers will have to be rebuilt the old way
# (preserve-libs).
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
FFMPEG_SUBSLOT=58.60.60

SOC_PATCHES=(
	ffmpeg-rpi-6.1-r2.patch
)

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_MIN_CLONE_TYPE="single"
	EGIT_REPO_URI="https://git.ffmpeg.org/ffmpeg.git"
fi

inherit flag-o-matic multilib multilib-minimal toolchain-funcs ${SCM}

DESCRIPTION="Complete solution to record/convert/stream audio and video. Includes libavcodec"
HOMEPAGE="https://ffmpeg.org/"
SRC_URI="soc? ( "${SOC_PATCHES[@]/#/https://dev.gentoo.org/~chewi/distfiles/}" )"
if [ "${PV#9999}" != "${PV}" ] ; then
	:
elif [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
	SRC_URI+=" mirror://gentoo/${P}.tar.xz"
else # Release
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ffmpeg.asc
	inherit verify-sig
	SRC_URI+=" https://ffmpeg.org/releases/${P/_/-}.tar.xz"
	SRC_URI+=" verify-sig? ( https://ffmpeg.org/releases/${P/_/-}.tar.xz.asc )"

	BDEPEND=" verify-sig? ( sec-keys/openpgp-keys-ffmpeg )"
fi
FFMPEG_REVISION="${PV#*_p}"

SLOT="0/${FFMPEG_SUBSLOT}"
LICENSE="
	!gpl? ( LGPL-2.1 )
	gpl? ( GPL-2 )
	amr? (
		gpl? ( GPL-3 )
		!gpl? ( LGPL-3 )
	)
	gmp? (
		gpl? ( GPL-3 )
		!gpl? ( LGPL-3 )
	)
	libaribb24? (
		gpl? ( GPL-3 )
		!gpl? ( LGPL-3 )
	)
	encode? (
		amrenc? (
			gpl? ( GPL-3 )
			!gpl? ( LGPL-3 )
		)
	)
	samba? ( GPL-3 )
"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
fi

# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAG_MAP=(
		+bzip2:bzlib cpudetection:runtime-cpudetect debug gcrypt +gnutls gmp
		+gpl hardcoded-tables +iconv libxml2 lzma +network opencl
		openssl +postproc samba:libsmbclient sdl:ffplay sdl:sdl2 vaapi vdpau vulkan
		X:xlib X:libxcb X:libxcb-shm X:libxcb-xfixes +zlib
		# libavdevice options
		cdio:libcdio iec61883:libiec61883 ieee1394:libdc1394 libcaca openal
		opengl
		# indevs
		libv4l:libv4l2 pulseaudio:libpulse libdrm jack:libjack
		# decoders
		amr:libopencore-amrwb amr:libopencore-amrnb codec2:libcodec2 +dav1d:libdav1d fdk:libfdk-aac
		jpeg2k:libopenjpeg jpegxl:libjxl bluray:libbluray gme:libgme gsm:libgsm
		libaribb24 modplug:libmodplug opus:libopus qsv:libvpl libilbc librtmp ssh:libssh
		speex:libspeex srt:libsrt svg:librsvg nvenc:ffnvcodec
		vorbis:libvorbis vpx:libvpx zvbi:libzvbi
		# libavfilter options
		appkit
		bs2b:libbs2b chromaprint cuda:cuda-llvm flite:libflite fontconfig frei0r
		fribidi:libfribidi glslang:libglslang ladspa lcms:lcms2 libass libplacebo
		libtesseract lv2 rubberband:librubberband shaderc:libshaderc truetype:libfreetype
		truetype:libharfbuzz vidstab:libvidstab vmaf:libvmaf zeromq:libzmq zimg:libzimg
		# libswresample options
		libsoxr
		# Threads; we only support pthread for now but ffmpeg supports more
		+threads:pthreads
)

# Same as above but for encoders, i.e. they do something only with USE=encode.
FFMPEG_ENCODER_FLAG_MAP=(
	amf amrenc:libvo-amrwbenc kvazaar:libkvazaar libaom	mp3:libmp3lame
	openh264:libopenh264 rav1e:librav1e snappy:libsnappy svt-av1:libsvtav1
	theora:libtheora twolame:libtwolame webp:libwebp x264:libx264
	x265:libx265 xvid:libxvid
)

IUSE="
	alsa chromium doc +encode oss +pic sndio static-libs test v4l soc
	${FFMPEG_FLAG_MAP[@]%:*}
	${FFMPEG_ENCODER_FLAG_MAP[@]%:*}
"

# Strings for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
ARM_CPU_FEATURES=(
	cpu_flags_arm_thumb:armv5te
	cpu_flags_arm_v6:armv6
	cpu_flags_arm_thumb2:armv6t2
	cpu_flags_arm_neon:neon
	cpu_flags_arm_vfp:vfp
	cpu_flags_arm_vfpv3:vfpv3
	cpu_flags_arm_v8:armv8
	cpu_flags_arm_asimddp:dotprod
	cpu_flags_arm_i8mm:i8mm
)
ARM_CPU_REQUIRED_USE="
	arm64? ( cpu_flags_arm_v8 )
	cpu_flags_arm_v8? ( cpu_flags_arm_vfpv3 cpu_flags_arm_neon )
	cpu_flags_arm_neon? (
		cpu_flags_arm_vfp
		arm? ( cpu_flags_arm_thumb2 )
	)
	cpu_flags_arm_vfpv3? ( cpu_flags_arm_vfp )
	cpu_flags_arm_thumb2? ( cpu_flags_arm_v6 )
	cpu_flags_arm_v6? (
		arm? ( cpu_flags_arm_thumb )
	)
"
MIPS_CPU_FEATURES=( mipsdspr1:mipsdsp mipsdspr2 mipsfpu )
PPC_CPU_FEATURES=( cpu_flags_ppc_altivec:altivec cpu_flags_ppc_vsx:vsx cpu_flags_ppc_vsx2:power8 )
PPC_CPU_REQUIRED_USE="
	cpu_flags_ppc_vsx? ( cpu_flags_ppc_altivec )
	cpu_flags_ppc_vsx2? ( cpu_flags_ppc_vsx )
"
X86_CPU_FEATURES_RAW=( 3dnow:amd3dnow 3dnowext:amd3dnowext aes:aesni avx:avx avx2:avx2 fma3:fma3 fma4:fma4 mmx:mmx
					   mmxext:mmxext sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4 sse4_2:sse42 xop:xop )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
X86_CPU_REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma4? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma3? ( cpu_flags_x86_avx )
	cpu_flags_x86_xop?  ( cpu_flags_x86_avx )
	cpu_flags_x86_avx?  ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_aes? ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_sse4_2?  ( cpu_flags_x86_sse4_1 )
	cpu_flags_x86_sse4_1?  ( cpu_flags_x86_ssse3 )
	cpu_flags_x86_ssse3?  ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse3?  ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2?  ( cpu_flags_x86_sse )
	cpu_flags_x86_sse?  ( cpu_flags_x86_mmxext )
	cpu_flags_x86_mmxext?  ( cpu_flags_x86_mmx )
	cpu_flags_x86_3dnowext?  ( cpu_flags_x86_3dnow )
	cpu_flags_x86_3dnow?  ( cpu_flags_x86_mmx )
"

CPU_FEATURES_MAP=(
	${ARM_CPU_FEATURES[@]}
	${MIPS_CPU_FEATURES[@]}
	${PPC_CPU_FEATURES[@]}
	${X86_CPU_FEATURES[@]}
)
IUSE="${IUSE}
	${CPU_FEATURES_MAP[@]%:*}"

CPU_REQUIRED_USE="
	${ARM_CPU_REQUIRED_USE}
	${PPC_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}
"

FFTOOLS=( aviocat cws2fws ffescape ffeval ffhash fourcc2pixfmt
		  graph2dot ismindex pktdumper qt-faststart sidxindex trasher )
IUSE="${IUSE} ${FFTOOLS[@]/#/+fftools_}"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	amf? ( media-video/amdgpu-pro-amf:= )
	amr? ( >=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}] )
	bluray? ( >=media-libs/libbluray-0.3.0-r1:=[${MULTILIB_USEDEP}] )
	bs2b? ( >=media-libs/libbs2b-3.1.0-r1[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	cdio? ( >=dev-libs/libcdio-paranoia-0.90_p1-r1[${MULTILIB_USEDEP}] )
	chromaprint? ( >=media-libs/chromaprint-1.2-r1[${MULTILIB_USEDEP}] )
	codec2? ( media-libs/codec2[${MULTILIB_USEDEP}] )
	dav1d? ( >=media-libs/dav1d-0.5.0:0=[${MULTILIB_USEDEP}] )
	encode? (
		amrenc? ( >=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}] )
		kvazaar? ( >=media-libs/kvazaar-2.0.0[${MULTILIB_USEDEP}] )
		mp3? ( >=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}] )
		openh264? ( >=media-libs/openh264-1.4.0-r1:=[${MULTILIB_USEDEP}] )
		rav1e? ( >=media-video/rav1e-0.5:=[capi] )
		snappy? ( >=app-arch/snappy-1.1.2-r1:=[${MULTILIB_USEDEP}] )
		theora? (
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
			>=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}]
		)
		twolame? ( >=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}] )
		webp? ( >=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}] )
		x264? ( >=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}] )
		x265? ( >=media-libs/x265-1.6:=[${MULTILIB_USEDEP}] )
		xvid? ( >=media-libs/xvid-1.3.2-r1[${MULTILIB_USEDEP}] )
	)
	fdk? ( >=media-libs/fdk-aac-0.1.3:=[${MULTILIB_USEDEP}] )
	flite? ( >=app-accessibility/flite-1.4-r4[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	frei0r? ( media-plugins/frei0r-plugins[${MULTILIB_USEDEP}] )
	fribidi? ( >=dev-libs/fribidi-0.19.6[${MULTILIB_USEDEP}] )
	gcrypt? ( >=dev-libs/libgcrypt-1.6:0=[${MULTILIB_USEDEP}] )
	glslang? ( dev-util/glslang:=[${MULTILIB_USEDEP}] )
	gme? ( >=media-libs/game-music-emu-0.6.0[${MULTILIB_USEDEP}] )
	gmp? ( >=dev-libs/gmp-6:0=[${MULTILIB_USEDEP}] )
	gsm? ( >=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	iec61883? (
		>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		>=media-libs/libdc1394-2.2.1:2=[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-2.1:2=[${MULTILIB_USEDEP}] )
	jpegxl? ( >=media-libs/libjxl-0.7.0:=[$MULTILIB_USEDEP] )
	lcms? ( >=media-libs/lcms-2.13:2[$MULTILIB_USEDEP] )
	libaom? ( >=media-libs/libaom-1.0.0-r1:=[${MULTILIB_USEDEP}] )
	libaribb24? ( >=media-libs/aribb24-1.0.3-r2[${MULTILIB_USEDEP}] )
	libass? ( >=media-libs/libass-0.11.0:=[${MULTILIB_USEDEP}] )
	libcaca? ( >=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}] )
	libdrm? ( x11-libs/libdrm[${MULTILIB_USEDEP}] )
	libilbc? ( >=media-libs/libilbc-2[${MULTILIB_USEDEP}] )
	libplacebo? ( >=media-libs/libplacebo-4.192.0:=[$MULTILIB_USEDEP] )
	librtmp? ( >=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}] )
	libsoxr? ( >=media-libs/soxr-0.1.0[${MULTILIB_USEDEP}] )
	libtesseract? ( >=app-text/tesseract-4.1.0-r1[${MULTILIB_USEDEP}] )
	libv4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	libxml2? ( dev-libs/libxml2:=[${MULTILIB_USEDEP}] )
	lv2? ( media-libs/lv2[${MULTILIB_USEDEP}] media-libs/lilv[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/libglvnd[X,${MULTILIB_USEDEP}] )
	opus? ( >=media-libs/opus-1.0.2-r2[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	qsv? ( media-libs/oneVPL[${MULTILIB_USEDEP}] )
	rubberband? ( >=media-libs/rubberband-1.8.1-r1[${MULTILIB_USEDEP}] )
	samba? ( >=net-fs/samba-3.6.23-r1[client,${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[sound,video,${MULTILIB_USEDEP}] )
	shaderc? ( media-libs/shaderc[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	soc? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] )
	srt? ( >=net-libs/srt-1.3.0:=[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh-0.6.0:=[sftp,${MULTILIB_USEDEP}] )
	svg? (
		gnome-base/librsvg:2=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	nvenc? ( >=media-libs/nv-codec-headers-11.1.5.3 )
	svt-av1? ( >=media-libs/svt-av1-0.9.0[${MULTILIB_USEDEP}] )
	truetype? (
		>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
		media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	)
	vaapi? ( >=media-libs/libva-1.2.1-r1:0=[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}] )
	vidstab? ( >=media-libs/vidstab-1.1.0[${MULTILIB_USEDEP}] )
	vmaf? ( >=media-libs/libvmaf-2.0.0[${MULTILIB_USEDEP}] )
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vpx? ( >=media-libs/libvpx-1.4.0:=[${MULTILIB_USEDEP}] )
	vulkan? ( >=media-libs/vulkan-loader-1.3.255:=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.4:=[${MULTILIB_USEDEP}]
	)
	zeromq? ( >=net-libs/zeromq-4.2.1:= )
	zimg? ( >=media-libs/zimg-2.7.4:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zvbi? ( >=media-libs/zvbi-0.2.35[${MULTILIB_USEDEP}] )
"

RDEPEND="${RDEPEND}
	openssl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
	!openssl? ( gnutls? ( >=net-libs/gnutls-2.12.23-r6:=[${MULTILIB_USEDEP}] ) )
"

DEPEND="${RDEPEND}
	amf? ( media-libs/amf-headers )
	ladspa? ( >=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}] )
	v4l? ( sys-kernel/linux-headers )
	vulkan? ( >=dev-util/vulkan-headers-1.3.255 )
"

# += for verify-sig above
BDEPEND+="
	>=dev-build/make-3.81
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( || ( >=dev-lang/nasm-2.13 >=dev-lang/yasm-1.3 ) )
	cuda? ( >=sys-devel/clang-7[llvm_targets_NVPTX] )
	doc? ( sys-apps/texinfo )
	test? ( net-misc/wget app-alternatives/bc )
"

# Code requiring FFmpeg to be built under gpl license
GPL_REQUIRED_USE="
	postproc? ( gpl )
	frei0r? ( gpl )
	cdio? ( gpl )
	rubberband? ( gpl )
	vidstab? ( gpl )
	samba? ( gpl )
	encode? (
		x264? ( gpl )
		x265? ( gpl )
		xvid? ( gpl )
	)
"
REQUIRED_USE="
	chromium? ( opus )
	cuda? ( nvenc )
	fftools_cws2fws? ( zlib )
	glslang? ( vulkan !shaderc )
	libv4l? ( v4l )
	shaderc? ( vulkan !glslang )
	soc? ( libdrm )
	test? ( encode )
	${GPL_REQUIRED_USE}
	${CPU_REQUIRED_USE}"
RESTRICT="
	!test? ( test )
	gpl? ( openssl? ( bindist ) fdk? ( bindist ) )
"

S=${WORKDIR}/${P/_/-}

PATCHES=(
	"${FILESDIR}"/chromium-r2.patch
	"${FILESDIR}"/${PN}-6.1-wint-conversion.patch
	"${FILESDIR}"/${PN}-6.0-fix-lto-type-mismatch.patch
	"${FILESDIR}"/${PN}-6.1-opencl-parallel-gmake-fix.patch
	"${FILESDIR}"/${PN}-6.1-gcc-14.patch
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libavutil/avconfig.h
)

pkg_setup() {
	# ffmpeg[chromaprint] depends on chromaprint, and chromaprint[tools] depends on ffmpeg.
	# May cause breakage while updating, #862996, #625210, #833821.
	if has_version media-libs/chromaprint[tools] && use chromaprint; then
		ewarn "You have media-libs/chromaprint installed with 'tools' USE flag, which "
		ewarn "links to ffmpeg, and you have enabled 'chromaprint' USE flag for ffmpeg, "
		ewarn "which links to chromaprint. This may cause issues while rebuilding ffmpeg."
		ewarn ""
		ewarn "If your build fails to 'ERROR: chromaprint not found', rebuild chromaprint "
		ewarn "without the 'tools' use flag first, then rebuild ffmpeg, and then finally enable "
		ewarn "'tools' USE flag for chromaprint. See #862996."
	fi
}

src_prepare() {
	if [[ "${PV%_p*}" != "${PV}" ]] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi

	use soc &&
		eapply "${SOC_PATCHES[@]/#/${DISTDIR}/}"

	default

	# -fdiagnostics-color=auto gets appended after user flags which
	# will ignore user's preference.
	sed -i -e '/check_cflags -fdiagnostics-color=auto/d' configure || die

	ln -snf "${FILESDIR}"/chromium.c chromium.c || die
	echo 'include $(SRC_PATH)/ffbuild/libffmpeg.mak' >> Makefile || die
}

multilib_src_configure() {
	local myconf=( )

	# Conditional patch options
	use soc && myconf+=( --enable-v4l2-request --enable-libudev --enable-sand )

	# bug 842201
	use ia64 && tc-is-gcc && append-flags \
		-fno-tree-ccp \
		-fno-tree-dominator-opts \
		-fno-tree-fre \
		-fno-code-hoisting \
		-fno-tree-pre \
		-fno-tree-vrp

	local ffuse=( "${FFMPEG_FLAG_MAP[@]}" )
	use openssl && myconf+=( --enable-nonfree )
	use samba && myconf+=( --enable-version3 )

	# Encoders
	if use encode ; then
		ffuse+=( "${FFMPEG_ENCODER_FLAG_MAP[@]}" )

		# Licensing.
		if use amrenc ; then
			myconf+=( --enable-version3 )
		fi
	else
		myconf+=( --disable-encoders )
	fi

	# Indevs
	use v4l || myconf+=( --disable-indev=v4l2 --disable-outdev=v4l2 )
	for i in alsa oss jack sndio ; do
		use ${i} || myconf+=( --disable-indev=${i} )
	done

	# Outdevs
	for i in alsa oss sndio ; do
		use ${i} || myconf+=( --disable-outdev=${i} )
	done

	# Decoders
	use amr && myconf+=( --enable-version3 )
	use gmp && myconf+=( --enable-version3 )
	use libaribb24 && myconf+=( --enable-version3 )
	use fdk && use gpl && myconf+=( --enable-nonfree )

	for i in "${ffuse[@]#+}" ; do
		myconf+=( $(use_enable ${i%:*} ${i#*:}) )
	done

	if use openssl ; then
		myconf+=( --disable-gnutls )
		has_version dev-libs/openssl:0/3 && myconf+=( --enable-version3 )
	fi

	# (temporarily) disable non-multilib deps
	if ! multilib_is_native_abi; then
		for i in librav1e libzmq ; do
			myconf+=( --disable-${i} )
		done
	fi

	# CPU features
	for i in "${CPU_FEATURES_MAP[@]}" ; do
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
	for i in $(get-flag mcpu) $(get-flag march) ; do
		[[ ${i} = native ]] && i="host" # bug #273421
		myconf+=( --cpu=${i} )
		break
	done

	# LTO support, bug #566282, bug #754654, bug #772854
	if [[ ${ABI} != x86 ]] && tc-is-lto; then
		# Respect -flto value, e.g -flto=thin
		local v="$(get-flag flto)"
		[[ -n ${v} ]] && myconf+=( "--enable-lto=${v}" ) || myconf+=( "--enable-lto" )
	fi
	filter-lto

	# Mandatory configuration
	myconf=(
		--disable-libaribcaption # libaribcaption is not packaged (yet?)
		--enable-avfilter
		--disable-stripping
		# This is only for hardcoded cflags; those are used in configure checks that may
		# interfere with proper detections, bug #671746 and bug #645778
		# We use optflags, so that overrides them anyway.
		--disable-optimizations
		--disable-libcelt # bug #664158
		"${myconf[@]}"
	)

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf+=( --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}- --host-cc="$(tc-getBUILD_CC)" )
		case ${CHOST} in
			*mingw32*)
				myconf+=( --target-os=mingw32 )
				;;
			*linux*)
				myconf+=( --target-os=linux )
				;;
		esac
	fi

	# doc
	myconf+=(
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable doc htmlpages)
		$(multilib_native_enable manpages)
	)

	# Use --extra-libs if needed for LIBS
	set -- "${S}/configure" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--mandir="${EPREFIX}/usr/share/man" \
		--enable-shared \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--strip="$(tc-getSTRIP)" \
		--ranlib="$(tc-getRANLIB)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--optflags="${CFLAGS}" \
		$(use_enable static-libs static) \
		"${myconf[@]}" \
		${EXTRA_FFMPEG_CONF}
	echo "${@}"
	"${@}" || die
}

multilib_src_compile() {
	emake V=1

	if multilib_is_native_abi; then
		for i in "${FFTOOLS[@]}" ; do
			if use fftools_${i} ; then
				emake V=1 tools/${i}$(get_exeext)
			fi
		done

		use chromium &&
			emake V=1 libffmpeg
	fi
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}/libpostproc:${BUILD_DIR}/libswscale:${BUILD_DIR}/libswresample:${BUILD_DIR}/libavcodec:${BUILD_DIR}/libavdevice:${BUILD_DIR}/libavfilter:${BUILD_DIR}/libavformat:${BUILD_DIR}/libavutil" \
		emake V=1 fate -k
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install install-doc

	if multilib_is_native_abi; then
		for i in "${FFTOOLS[@]}" ; do
			if use fftools_${i} ; then
				dobin tools/${i}$(get_exeext)
			fi
		done

		use chromium &&
			emake V=1 DESTDIR="${D}" install-libffmpeg
	fi
}

multilib_src_install_all() {
	dodoc Changelog README.md CREDITS doc/*.txt doc/APIchanges
	[ -f "RELEASE_NOTES" ] && dodoc "RELEASE_NOTES"

	use amf && elog "To use AMF, prefix the ffmpeg call with the 'vk_pro' wrapper script, e.g. `vk_pro ffmpeg -vcodec h264_amf [...]`"
}
