# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

COMMIT="556e3ba65d21006a8732d66e4aa8f810cee39ed0"
DESCRIPTION="FFmpeg built specifically for codec support in Chromium-based browsers"
HOMEPAGE="https://ffmpeg.org/"
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${P}.tar.xz"

SLOT="${PV}"
LICENSE="
	!gpl? ( LGPL-2.1 )
	gpl? ( GPL-2 )
"

KEYWORDS="~amd64 ~arm ~arm64"

# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAG_MAP=(
		cpudetection:runtime-cpudetect debug
		+gpl
		vaapi vdpau vulkan
		# decoders
		mmal
		nvenc:ffnvcodec
		# Threads; we only support pthread for now but ffmpeg supports more
		+threads:pthreads
)

IUSE="
	${FFMPEG_FLAG_MAP[@]%:*}
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
	${X86_CPU_FEATURES[@]}
)
IUSE="${IUSE}
	${CPU_FEATURES_MAP[@]%:*}"

CPU_REQUIRED_USE="
	${ARM_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}
"

RDEPEND="
	mmal? ( media-libs/raspberrypi-userland )
	>=media-libs/opus-1.0.2-r2
	vaapi? ( >=media-libs/libva-1.2.1-r1:0= )
	nvenc? ( >=media-libs/nv-codec-headers-11.1.5.3 )
	vdpau? ( >=x11-libs/libvdpau-0.7 )
	vulkan? ( >=media-libs/vulkan-loader-1.3.255:= )
"

DEPEND="${RDEPEND}
	vulkan? ( >=dev-util/vulkan-headers-1.3.255 )
"
BDEPEND="
	>=sys-devel/make-3.81
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( || ( >=dev-lang/nasm-2.13 >=dev-lang/yasm-1.3 ) )
"

REQUIRED_USE="
	${CPU_REQUIRED_USE}"
RESTRICT="
	test
"

PATCHES=(
	"${FILESDIR}"/${PN}-117.patch
	"${FILESDIR}"/chromium.patch
)

src_prepare() {
	export revision=git-N-g${COMMIT:0:10}
	default

	# -fdiagnostics-color=auto gets appended after user flags which
	# will ignore user's preference.
	sed -i -e '/check_cflags -fdiagnostics-color=auto/d' configure || die

	echo 'include $(SRC_PATH)/ffbuild/libffmpeg.mak' >> Makefile || die
}

src_configure() {
	local myconf=( )

	# Bug #918997. Will probably be fixed upstream in the next release.
	use vulkan && append-ldflags -Wl,-z,muldefs

	# bug 842201
	use ia64 && tc-is-gcc && append-flags \
		-fno-tree-ccp \
		-fno-tree-dominator-opts \
		-fno-tree-fre \
		-fno-code-hoisting \
		-fno-tree-pre \
		-fno-tree-vrp

	local ffuse=( "${FFMPEG_FLAG_MAP[@]}" )

	for i in "${ffuse[@]#+}" ; do
		myconf+=( $(use_enable ${i%:*} ${i#*:}) )
	done

	# CPU features
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		use ${i%:*} || myconf+=( --disable-${i#*:} )
	done

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
	if [[ ${ABI} != x86 ]] && is-flagq "-flto*"; then
		# Respect -flto value, e.g -flto=thin
		local v="$(get-flag flto)"
		[[ -n ${v} ]] && myconf+=( "--enable-lto=${v}" ) || myconf+=( "--enable-lto" )
	fi
	filter-lto

	# Mandatory configuration
	myconf=(
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

	# Use --extra-libs if needed for LIBS
	set -- "${S}/configure" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--strip="$(tc-getSTRIP)" \
		--ranlib="$(tc-getRANLIB)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--optflags="${CFLAGS}" \
		--disable-all \
		--disable-autodetect \
		--disable-error-resilience \
		--disable-everything \
		--disable-faan \
		--disable-iconv \
		--disable-network \
		--enable-avcodec \
		--enable-avformat \
		--enable-avutil \
		--enable-libopus \
		--enable-decoder=aac,flac,h264,libopus,mp3,pcm_alaw,pcm_f32le,pcm_mulaw,pcm_s16be,pcm_s16le,pcm_s24be,pcm_s24le,pcm_s32le,pcm_u8,theora,vorbis,vp8 \
		--enable-demuxer=aac,flac,matroska,mov,mp3,ogg,wav \
		--enable-parser=aac,flac,h264,mpegaudio,opus,vorbis,vp3,vp8,vp9 \
		--enable-pic \
		--enable-static \
		"${myconf[@]}" \
		${EXTRA_FFMPEG_CONF}

	echo "${@}"
	"${@}" || die
}

src_compile() {
	emake V=1 libffmpeg
}

src_install() {
	emake V=1 DESTDIR="${D}" install-libffmpeg
}
