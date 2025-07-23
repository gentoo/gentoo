# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

FFMPEG_SOC_PATCH=ffmpeg-rpi-6.1-r3.patch
FFMPEG_SUBSLOT=58.60.60 # avutil.avcodec.avformat SONAME

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		https://git.ffmpeg.org/ffmpeg.git
		https://github.com/FFmpeg/FFmpeg.git
	)
else
	inherit verify-sig
	SRC_URI="
		https://ffmpeg.org/releases/ffmpeg-${PV}.tar.xz
		verify-sig? ( https://ffmpeg.org/releases/ffmpeg-${PV}.tar.xz.asc )
		${FFMPEG_SOC_PATCH:+"
			soc? ( https://dev.gentoo.org/~chewi/distfiles/${FFMPEG_SOC_PATCH} )
		"}
		https://dev.gentoo.org/~ionen/distfiles/ffmpeg-$(ver_cut 1-2)-patchset-1.tar.xz
	"
	S=${WORKDIR}/ffmpeg-${PV} # avoid ${P} for ffmpeg-compat
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
fi

DESCRIPTION="Complete solution to record/convert/stream audio and video"
HOMEPAGE="https://ffmpeg.org/"

[[ ${PN} == *-compat ]] && FFMPEG_UNSLOTTED= || FFMPEG_UNSLOTTED=1

FFMPEG_IUSE_MAP=(
	# [+]flag[:[^][!]opt1,...][@<v3|nonfree>]], ^ = native-only, ! = override
	# remember to keep LICENSE, REQUIRED_USE, and RESTRICT in sync
	X:libxcb,libxcb-shape,libxcb-shm,libxcb-xfixes,xlib
	alsa
	amf
	amrenc:libvo-amrwbenc@v3
	amr:libopencore-amrnb,libopencore-amrwb@v3
	appkit
	bluray:libbluray
	bs2b:libbs2b
	bzip2:bzlib
	cdio:libcdio
	chromaprint
	codec2:libcodec2
	cuda:cuda-llvm
	+dav1d:libdav1d
	${FFMPEG_UNSLOTTED:+doc:^htmlpages}
	+drm:libdrm
	fdk:libfdk-aac@nonfree
	flite:libflite
	+fontconfig:libfontconfig
	frei0r
	fribidi:libfribidi
	gcrypt
	gme:libgme
	gmp:@v3
	+gnutls # unused if USE=openssl, default for bug #905113,#917627
	+gpl
	gsm:libgsm
	iec61883:libiec61883
	ieee1394:libdc1394
	jack:libjack
	jpeg2k:libopenjpeg
	jpegxl:libjxl
	kvazaar:libkvazaar
	ladspa
	lame:libmp3lame
	lcms:lcms2
	libaom
	libaribb24:@v3 # reminder: req use on gpl unneeded if >=1.0.4 (not in tree)
	+libass
	libcaca
	libilbc
	libplacebo
	librtmp:librtmp
	libsoxr
	libtesseract
	lv2
	lzma
	modplug:libmodplug
	npp:^libnpp@nonfree # no multilib
	nvenc:cuvid,ffnvcodec,nvdec,nvenc
	openal
	opencl
	opengl
	openh264:libopenh264
	openmpt:libopenmpt
	openssl:openssl,!gnutls@v3ifgpl # still LGPL2.1+ if USE=-gpl
	opus:libopus
	+postproc # exposed as a USE for clarity with the GPL requirement
	pulseaudio:libpulse
	qsv:libvpl
	rabbitmq:^librabbitmq # no multilib
	rav1e:^librav1e # no multilib
	rubberband:librubberband
	samba:libsmbclient@v3 # GPL-3+ only
	sdl:sdl2
	shaderc:libshaderc
	snappy:libsnappy
	sndio
	speex:libspeex
	srt:libsrt
	ssh:libssh
	svg:librsvg
	svt-av1:libsvtav1
	theora:libtheora
	+truetype:libfreetype,libharfbuzz
	twolame:libtwolame
	v4l:libv4l2
	vaapi
	vdpau
	vidstab:libvidstab
	vmaf:libvmaf
	vorbis:libvorbis
	vpx:libvpx
	vulkan
	webp:libwebp
	x264:libx264
	x265:libx265
	+xml:libxml2
	xvid:libxvid
	zeromq:^libzmq # no multilib
	zimg:libzimg
	+zlib
	zvbi:libzvbi
)

# all-rights is used to express the GPL incompatibility (RESTRICT=bindist)
LICENSE="
	gpl? (
		GPL-2+
		amr? ( GPL-3+ ) amrenc? ( GPL-3+ ) libaribb24? ( GPL-3+ )
		gmp? ( GPL-3+ ) openssl? ( GPL-3+ )
		fdk? ( all-rights-reserved ) npp? ( all-rights-reserved )
	)
	!gpl? (
		LGPL-2.1+
		amr? ( LGPL-3+ ) amrenc? ( LGPL-3+ ) libaribb24? ( LGPL-3+ )
		gmp? ( LGPL-3+ )
	)
	samba? ( GPL-3+ )
"
[[ ${FFMPEG_UNSLOTTED} ]] && : 0 || : "$(ver_cut 1)"
SLOT="${_}/${FFMPEG_SUBSLOT}"
IUSE="
	${FFMPEG_IUSE_MAP[*]%:*}
	${FFMPEG_UNSLOTTED:+chromium}
	${FFMPEG_SOC_PATCH:+soc}
"
REQUIRED_USE="
	cuda? ( nvenc )
	fribidi? ( truetype )
	gmp? ( !librtmp )
	libplacebo? ( vulkan )
	npp? ( nvenc )
	shaderc? ( vulkan )
	libaribb24? ( gpl ) cdio? ( gpl ) frei0r? ( gpl ) postproc? ( gpl )
	rubberband? ( gpl ) samba? ( gpl ) vidstab? ( gpl ) x264? ( gpl )
	x265? ( gpl ) xvid? ( gpl )
	${FFMPEG_UNSLOTTED:+chromium? ( opus )}
	${FFMPEG_SOC_PATCH:+soc? ( drm )}
"
RESTRICT="gpl? ( fdk? ( bindist ) npp? ( bindist ) )"

# dlopen: amdgpu-pro-amf, vulkan-loader
COMMON_DEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXv[${MULTILIB_USEDEP}]
		x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	amr? ( media-libs/opencore-amr[${MULTILIB_USEDEP}] )
	amrenc? ( media-libs/vo-amrwbenc[${MULTILIB_USEDEP}] )
	bluray? ( media-libs/libbluray:=[${MULTILIB_USEDEP}] )
	bs2b? ( media-libs/libbs2b[${MULTILIB_USEDEP}] )
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	cdio? ( dev-libs/libcdio-paranoia:=[${MULTILIB_USEDEP}] )
	chromaprint? ( media-libs/chromaprint:=[${MULTILIB_USEDEP}] )
	codec2? ( media-libs/codec2:=[${MULTILIB_USEDEP}] )
	dav1d? ( media-libs/dav1d:=[${MULTILIB_USEDEP}] )
	drm? ( x11-libs/libdrm[${MULTILIB_USEDEP}] )
	fdk? ( media-libs/fdk-aac:=[${MULTILIB_USEDEP}] )
	flite? ( app-accessibility/flite[${MULTILIB_USEDEP}] )
	fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	frei0r? ( media-plugins/frei0r-plugins[${MULTILIB_USEDEP}] )
	fribidi? ( dev-libs/fribidi[${MULTILIB_USEDEP}] )
	gcrypt? ( dev-libs/libgcrypt:=[${MULTILIB_USEDEP}] )
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	gmp? ( dev-libs/gmp:=[${MULTILIB_USEDEP}] )
	gnutls? ( !openssl? (
		net-libs/gnutls:=[${MULTILIB_USEDEP}]
	) )
	gsm? ( media-sound/gsm[${MULTILIB_USEDEP}] )
	iec61883? (
		media-libs/libiec61883[${MULTILIB_USEDEP}]
		sys-libs/libavc1394[${MULTILIB_USEDEP}]
		sys-libs/libraw1394[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		media-libs/libdc1394:2=[${MULTILIB_USEDEP}]
		sys-libs/libraw1394[${MULTILIB_USEDEP}]
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:2=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl:=[${MULTILIB_USEDEP}] )
	kvazaar? ( media-libs/kvazaar:=[${MULTILIB_USEDEP}] )
	lame? ( media-sound/lame[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms:2[${MULTILIB_USEDEP}] )
	libaom? ( media-libs/libaom:=[${MULTILIB_USEDEP}] )
	libaribb24? ( media-libs/aribb24[${MULTILIB_USEDEP}] )
	libass? ( media-libs/libass:=[${MULTILIB_USEDEP}] )
	libcaca? ( media-libs/libcaca[${MULTILIB_USEDEP}] )
	libilbc? ( media-libs/libilbc:=[${MULTILIB_USEDEP}] )
	libplacebo? ( media-libs/libplacebo:=[vulkan,${MULTILIB_USEDEP}] )
	librtmp? ( media-video/rtmpdump[${MULTILIB_USEDEP}] )
	libsoxr? ( media-libs/soxr[${MULTILIB_USEDEP}] )
	libtesseract? ( app-text/tesseract:=[${MULTILIB_USEDEP}] )
	lv2? (
		media-libs/lilv[${MULTILIB_USEDEP}]
		media-libs/lv2[${MULTILIB_USEDEP}]
	)
	lzma? ( app-arch/xz-utils[${MULTILIB_USEDEP}] )
	modplug? ( media-libs/libmodplug[${MULTILIB_USEDEP}] )
	npp? ( dev-util/nvidia-cuda-toolkit:= )
	openal? ( media-libs/openal[${MULTILIB_USEDEP}] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/libglvnd[X,${MULTILIB_USEDEP}] )
	openh264? ( media-libs/openh264:=[${MULTILIB_USEDEP}] )
	openmpt? ( media-libs/libopenmpt[${MULTILIB_USEDEP}] )
	openssl? ( >=dev-libs/openssl-3:=[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	qsv? ( media-libs/libvpl:=[${MULTILIB_USEDEP}] )
	rabbitmq? ( net-libs/rabbitmq-c:= )
	rav1e? ( >=media-video/rav1e-0.5:=[capi] )
	rubberband? ( media-libs/rubberband:=[${MULTILIB_USEDEP}] )
	samba? ( net-fs/samba:=[client,${MULTILIB_USEDEP}] )
	sdl? (
		media-libs/libsdl2[sound(+),video(+),${MULTILIB_USEDEP}]
		libplacebo? ( media-libs/libsdl2[vulkan] )
	)
	shaderc? ( media-libs/shaderc[${MULTILIB_USEDEP}] )
	snappy? ( app-arch/snappy:=[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	speex? ( media-libs/speex[${MULTILIB_USEDEP}] )
	srt? ( net-libs/srt:=[${MULTILIB_USEDEP}] )
	ssh? ( net-libs/libssh:=[sftp,${MULTILIB_USEDEP}] )
	svg? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		>=gnome-base/librsvg-2.52:2[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	svt-av1? ( >=media-libs/svt-av1-0.9:=[${MULTILIB_USEDEP}] )
	theora? ( media-libs/libtheora:=[encode,${MULTILIB_USEDEP}] )
	truetype? (
		media-libs/freetype:2[${MULTILIB_USEDEP}]
		media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	)
	twolame? ( media-sound/twolame[${MULTILIB_USEDEP}] )
	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )
	vaapi? ( media-libs/libva:=[X?,${MULTILIB_USEDEP}] )
	vdpau? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libvdpau[${MULTILIB_USEDEP}]
	)
	vidstab? ( media-libs/vidstab[${MULTILIB_USEDEP}] )
	vmaf? ( media-libs/libvmaf:=[${MULTILIB_USEDEP}] )
	vorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	vpx? ( media-libs/libvpx:=[${MULTILIB_USEDEP}] )
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	x264? ( media-libs/x264:=[${MULTILIB_USEDEP}] )
	x265? ( media-libs/x265:=[${MULTILIB_USEDEP}] )
	xml? ( dev-libs/libxml2:=[${MULTILIB_USEDEP}] )
	xvid? ( media-libs/xvid[${MULTILIB_USEDEP}] )
	zeromq? ( net-libs/zeromq:= )
	zimg? ( media-libs/zimg[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	zvbi? ( media-libs/zvbi[${MULTILIB_USEDEP}] )
	${FFMPEG_SOC_PATCH:+"
		soc? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	"}
"
RDEPEND="
	${COMMON_DEPEND}
	amf? ( media-video/amdgpu-pro-amf )
"
DEPEND="
	${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
	amf? ( media-libs/amf-headers )
	kernel_linux? ( >=sys-kernel/linux-headers-6 )
	ladspa? ( media-libs/ladspa-sdk )
	nvenc? ( >=media-libs/nv-codec-headers-12.1.14.0 )
	opencl? ( dev-util/opencl-headers )
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	app-alternatives/awk
	virtual/pkgconfig
	amd64? (
		|| (
			dev-lang/nasm
			dev-lang/yasm
		)
	)
	cuda? ( llvm-core/clang:*[llvm_targets_NVPTX] )
	${FFMPEG_UNSLOTTED:+"
		dev-lang/perl
		doc? ( sys-apps/texinfo )
	"}
"
[[ ${PV} != 9999 ]] &&
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-ffmpeg )"

DOCS=( CREDITS Changelog README.md doc/APIchanges )
[[ ${PV} != 9999 ]] && DOCS+=( RELEASE_NOTES )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libavutil/avconfig.h
)

PATCHES=(
	"${WORKDIR}"/patches
)

pkg_pretend() {
	# TODO: drop this after a few months
	if has_version "${CATEGORY}/${PN}[mp3]" && use !lame; then #952971
		ewarn "${PN}'s 'mp3' USE was renamed to 'lame', please enable it"
		ewarn "if wish to keep the ability to encode using media-sound/lame."
		ewarn "This is *not* needed if only want mp3 playback."
	fi
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] || return

	if use chromaprint && has_version 'media-libs/chromaprint[tools]'; then
		ewarn "media-libs/chromaprint is installed with USE=tools which links to"
		ewarn "ffmpeg, and USE=chromaprint is enabled on ffmpeg which links to"
		ewarn "chromaprint (circular). This may cause issues when updating ffmpeg."
		ewarn
		ewarn "If get a build failure with 'ERROR: chromaprint not found' or so,"
		ewarn "first rebuild chromaprint with USE=-tools, then rebuild ffmpeg, and"
		ewarn "then finally rebuild chromaprint with USE=tools again (bug #862996)."
	fi

	[[ ${EXTRA_FFMPEG_CONF} ]] && # drop this eventually
		die "EXTRA_FFMPEG_CONF is set in the environment, please use EXTRA_ECONF instead"
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		use verify-sig &&
			verify-sig_verify_detached "${DISTDIR}"/ffmpeg-${PV}.tar.xz{,.asc} \
				"${BROOT}"/usr/share/openpgp-keys/ffmpeg.asc
		default
	fi
}

src_prepare() {
	in_iuse chromium && PATCHES+=( "${FILESDIR}"/chromium-r3.patch )
	in_iuse soc && use soc && PATCHES+=( "${DISTDIR}"/${FFMPEG_SOC_PATCH} )

	default

	# respect user preferences
	sed -i '/cflags -fdiagnostics-color/d' configure || die

	# handle *FLAGS here to avoid repeating for each ABI below (bug #923491)
	FFMPEG_ENABLE_LTO=
	if tc-is-lto; then
		: "$(get-flag -flto)" # get -flto=<val> (e.g. =thin)
		FFMPEG_ENABLE_LTO=--enable-lto${_#-flto}
	fi
	filter-lto

	use elibc_musl && append-cppflags -D__musl__ #940733

	if use npp; then
		local cuda=${ESYSROOT}/opt/cuda/targets/$(usex amd64 x86_64 sbsa)-linux
		append-cppflags -I"${cuda}"/include
		append-ldflags -L"${cuda}"/lib
	fi
}

multilib_src_configure() {
	local conf=( "${S}"/configure ) # not autotools-based

	local prefix=${EPREFIX}/usr
	if [[ ! ${FFMPEG_UNSLOTTED} ]]; then
		prefix+=/lib/ffmpeg${SLOT%/*}
		# could get SONAME clashes, so prefer rpath over LDPATH
		conf+=(
			--enable-rpath
			--disable-doc
		)
	fi

	conf+=(
		--prefix="${prefix}"
		--libdir="${prefix}"/$(get_libdir)
		--shlibdir="${prefix}"/$(get_libdir)
		--mandir="${prefix}"/share/man
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html

		--ar="$(tc-getAR)"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--nm="$(tc-getNM)"
		--pkg-config="$(tc-getPKG_CONFIG)"
		--ranlib="$(tc-getRANLIB)"
		--disable-stripping

		# overrides users' -g/-O, let *FLAGS handle these
		--disable-debug
		--disable-optimizations
		--optflags=' '

		# pass option over *FLAGS due to special logic (bug #566282,#754654)
		${FFMPEG_ENABLE_LTO}

		# basic defaults that should not really need a USE
		--enable-iconv
		--enable-pic
		--enable-shared
		--disable-static
		$(multilib_native_enable manpages) # needs pod2man
		--disable-podpages
		--disable-txtpages

		# disabled primarily due to being unpackaged
		--disable-decklink
		--disable-libaribcaption
		--disable-libdavs2
		--disable-libklvanc
		--disable-libmysofa
		--disable-libopenvino
		--disable-libshine
		--disable-libtls
		--disable-libuavs3d
		--disable-libxavs
		--disable-libxavs2
		--disable-pocketsphinx
		--disable-rkmpp
		--disable-vapoursynth

		# disabled for other or additional reasons
		--disable-cuda-nvcc # prefer cuda-llvm for less issues
		--disable-libcelt # obsolete (bug #664158)
		--disable-libglslang # prefer USE=shaderc (bug #918989,#920283,#922333)
		--disable-liblensfun # https://trac.ffmpeg.org/ticket/9112 (abandoned?)
		--disable-libmfx # prefer libvpl for USE=qsv
		--disable-libopencv # leaving for later due to circular opencv[ffmpeg]
		--disable-librist # librist itself needs attention first (bug #822012)
		--disable-libtensorflow # causes headaches, and is gone
		--disable-mbedtls # messy with slots, tests underlinking issues
		--disable-mmal # prefer USE=soc
		--disable-omx # unsupported (bug #653386)
		--disable-omx-rpi # ^

		# to avoid obscure issues like bug #915384 and simplify the ebuild,
		# not passing the following (use EXTRA_ECONF if really must):
		# --cpu: adds -march=<exact> after the user's more adapted
		# =native, its logic also does not account for -mno-*
		# --disable/enable-<cpufeature>: safer to detect at runtime
	)

	in_iuse soc && use soc &&
		conf+=(
			--disable-epoxy
			--enable-libudev
			--enable-sand
			--enable-v4l2-request
		)

	# broken on x32 (bug #427004), and not PIC safe on x86 (bug #916067)
	[[ ${ABI} == @(x32|x86) ]] && conf+=( --disable-asm )

	# disable due to asm-related failures on ppc (bug #951464, ppc64be)
	# https://trac.ffmpeg.org/ticket/9604 (ppc64el)
	# https://trac.ffmpeg.org/ticket/10955 (ppc64el)
	# (review re-enabling if resolved, or if debian allows it again)
	use ppc || use ppc64 && conf+=( --disable-asm )

	if tc-is-cross-compiler; then
		conf+=(
			--enable-cross-compile
			--arch="$(tc-arch-kernel)"
			--cross-prefix="${CHOST}-"
			--host-cc="$(tc-getBUILD_CC)"
		)
		case ${CHOST} in
			*mingw32*) conf+=( --target-os=mingw32 );;
			*linux*) conf+=( --target-os=linux );;
		esac
	fi

	# import options from FFMPEG_IUSE_MAP
	local flag license mod v
	local -A optmap=() licensemap=()
	for v in "${FFMPEG_IUSE_MAP[@]}"; do
		[[ ${v} =~ \+?([^:]+):?([^@]*)@?(.*) ]] || die "${v}"
		flag=${BASH_REMATCH[1]}
		license=${BASH_REMATCH[3]}
		v=${BASH_REMATCH[2]:-${flag}}
		for v in ${v//,/ }; do
			mod=${v::1}
			v=${v#[\!\^]}
			if [[ ${mod} == '!' ]]; then
				if use ${flag}; then
					optmap[${v}]=--disable-${v}
					unset licensemap[${v}]
				fi
			elif [[ ! -v optmap[${v}] ]]; then
				if [[ ${mod} == '^' ]]; then
					optmap[${v}]=$(multilib_native_use_enable ${flag} ${v})
				else
					optmap[${v}]=$(use_enable ${flag} ${v})
				fi
				use ${flag} && licensemap[${v}]=${license}
			fi
		done
	done
	for license in "${licensemap[@]}"; do
		case ${license} in
			v3ifgpl) use gpl || continue ;&
			v3) optmap[v3]=--enable-version3 ;;
			nonfree) use gpl && optmap[nonfree]=--enable-nonfree ;;
		esac
	done
	conf+=(
		"${optmap[@]}"
		${EXTRA_ECONF}
	)

	einfo "${conf[*]}"
	"${conf[@]}" || die "configure failed, see ${BUILD_DIR}/ffbuild/config.log"
}

multilib_src_compile() {
	emake V=1
	in_iuse chromium && use chromium && multilib_is_native_abi &&
		emake V=1 libffmpeg
}

multilib_src_test() {
	local -x LD_LIBRARY_PATH=$(printf %s: "${BUILD_DIR}"/lib*)${LD_LIBRARY_PATH}
	emake V=1 -k fate
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install
	in_iuse chromium && use chromium && multilib_is_native_abi &&
		emake V=1 DESTDIR="${D}" install-libffmpeg
}
