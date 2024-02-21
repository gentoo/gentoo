# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These don't necessarily have to align with the upstream release.
BUILD_DEPS_COMMIT="2aafe061cd52a944cb3b5f86d1f25e9ad2a19bec"
ENET_COMMIT="c6bb0e50118d08252eee308de8412751218442d6"
MOONLIGHT_COMMIT="6e9ed871bc3e013386c775b2ee7d31deb1151068"
NANORS_COMMIT="e9e242e98e27037830490b2a752895ca68f75f8b"
TRAY_COMMIT="e08bdbe5aa7de0ad9c0ce36257016e07c7e6e2c0"
SWS_COMMIT="27b41f5ee154cca0fce4fe2955dd886d04e3a4ed"
WLRP_COMMIT="4264185db3b7e961e7f157e1cc4fd0ab75137568"
FFMPEG_VERSION="6.1.1"

# To make the node-modules tarball:
# PV=
# git fetch
# git checkout v$PV
# rm -rf node_modules
# npm install
# XZ_OPT=-9 tar --xform="s:^:Sunshine-$PV/:" -Jcf /var/cache/distfiles/sunshine-node-modules-$PV.tar.xz node_modules

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
else
	SRC_URI="
		https://github.com/LizardByte/Sunshine/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/LizardByte/build-deps/archive/${BUILD_DEPS_COMMIT}.tar.gz
			-> LizardByte-build-deps-${BUILD_DEPS_COMMIT}.tar.gz
		https://github.com/cgutman/enet/archive/${ENET_COMMIT}.tar.gz
			-> moonlight-enet-${ENET_COMMIT}.tar.gz
		https://github.com/moonlight-stream/moonlight-common-c/archive/${MOONLIGHT_COMMIT}.tar.gz
			-> moonlight-common-c-${MOONLIGHT_COMMIT}.tar.gz
		https://github.com/sleepybishop/nanors/archive/${NANORS_COMMIT}.tar.gz
			-> nanors-${NANORS_COMMIT}.tar.gz
		https://github.com/LizardByte/tray/archive/${TRAY_COMMIT}.tar.gz
			-> LizardByte-tray-${TRAY_COMMIT}.tar.gz
		https://gitlab.com/eidheim/Simple-Web-Server/-/archive/${SWS_COMMIT}/Simple-Web-Server-${SWS_COMMIT}.tar.bz2
		https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/archive/${WLRP_COMMIT}/wlr-protocols-${WLRP_COMMIT}.tar.bz2
		https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz
		https://dev.gentoo.org/~chewi/distfiles/${PN}-node-modules-${PV}.tar.xz
	"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/Sunshine-${PV}"
fi

inherit cmake fcaps flag-o-matic toolchain-funcs udev xdg

DESCRIPTION="Self-hosted game stream host for Moonlight"
HOMEPAGE="https://github.com/LizardByte/Sunshine"
LICENSE="GPL-3"
SLOT="0"
IUSE="cuda debug libdrm svt-av1 trayicon vaapi wayland X x264 x265"

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

REQUIRED_USE="
	${CPU_REQUIRED_USE}
	|| ( cuda libdrm wayland X )
"

CDEPEND="
	dev-libs/boost:=[nls]
	dev-libs/libevdev
	dev-libs/openssl:=
	media-libs/opus
	net-libs/miniupnpc:=
	net-misc/curl
	|| (
		media-libs/libpulse
		media-sound/apulse[sdk]
	)
	libdrm? (
		sys-libs/libcap
		x11-libs/libdrm
	)
	svt-av1? ( media-libs/svt-av1 )
	trayicon? (
		dev-libs/libayatana-appindicator
		x11-libs/libnotify
	)
	vaapi? ( media-libs/libva:=[wayland?,X?] )
	wayland? ( dev-libs/wayland )
	X? ( x11-libs/libX11 )
	x264? ( media-libs/x264:= )
	x265? ( media-libs/x265:= )
"

RDEPEND="
	${CDEPEND}
	media-libs/mesa[vaapi?]
	X? (
		x11-libs/libxcb
		x11-libs/libXfixes
		x11-libs/libXrandr
		x11-libs/libXtst
	)
"

DEPEND="
	${CDEPEND}
	media-libs/amf-headers
	media-libs/libva
	=media-libs/nv-codec-headers-12*
	wayland? ( dev-libs/wayland-protocols )
"

BDEPEND="
	net-libs/nodejs[npm]
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( || ( >=dev-lang/nasm-2.13 >=dev-lang/yasm-1.3 ) )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/${P}-vaapi.patch
	"${FILESDIR}"/${P}-no-x11.patch
	"${FILESDIR}"/${P}-system-deps.patch
)

# Make this mess a bit simpler.
CMAKE_IN_SOURCE_BUILD=1

# Make npm behave.
export npm_config_audit=false
export npm_config_color=false
export npm_config_foreground_scripts=true
export npm_config_loglevel=verbose
export npm_config_progress=false
export npm_config_save=false

src_unpack() {
	if [[ ${PV} = 9999* ]]; then
		local EGIT_REPO_URI="https://github.com/LizardByte/build-deps.git"
		local EGIT_SUBMODULES=( '-*' )
		local EGIT_CHECKOUT_DIR=${WORKDIR}/build-deps
		git-r3_src_unpack

		# Use upstream server like our ffmpeg package does, not GitHub.
		local EGIT_REPO_URI="https://git.ffmpeg.org/ffmpeg.git"
		local EGIT_SUBMODULES=( '-*' )
		local EGIT_CHECKOUT_DIR=${EGIT_CHECKOUT_DIR}/ffmpeg_sources/ffmpeg
		local EGIT_COMMIT=$(git --git-dir=build-deps/.git rev-parse HEAD:ffmpeg_sources/ffmpeg)
		local EGIT_BRANCH=release/$(ver_cut 1-2 ${FFMPEG_VERSION})
		git-r3_src_unpack

		local EGIT_REPO_URI="https://github.com/LizardByte/Sunshine.git"
		local EGIT_SUBMODULES=(
			third-party/{moonlight-common-c{,/enet},nanors,tray,Simple-Web-Server,wlr-protocols}
		)
		unset EGIT_CHECKOUT_DIR EGIT_COMMIT EGIT_BRANCH
		git-r3_src_unpack

		# This downloads things so must go in src_unpack to avoid the sandbox.
		cd "${S}" || die
		npm install || die
	else
		default
		ln -snf build-deps-${BUILD_DEPS_COMMIT} build-deps || die
		find moonlight-common-c-${MOONLIGHT_COMMIT} "${S}"/third-party build-deps/ffmpeg_sources \
			-mindepth 1 -type d -empty -delete || die
		ln -snf ../enet-${ENET_COMMIT} moonlight-common-c-${MOONLIGHT_COMMIT}/enet || die
		ln -snf ../../moonlight-common-c-${MOONLIGHT_COMMIT} "${S}"/third-party/moonlight-common-c || die
		ln -snf ../../nanors-${NANORS_COMMIT} "${S}"/third-party/nanors || die
		ln -snf ../../tray-${TRAY_COMMIT} "${S}"/third-party/tray || die
		ln -snf ../../Simple-Web-Server-${SWS_COMMIT} "${S}"/third-party/Simple-Web-Server || die
		ln -snf ../../wlr-protocols-${WLRP_COMMIT} "${S}"/third-party/wlr-protocols || die
		ln -snf ../../ffmpeg-${FFMPEG_VERSION} build-deps/ffmpeg_sources/ffmpeg || die
	fi
}

src_prepare() {
	# Apply general ffmpeg patches.
	cd "${WORKDIR}"/build-deps/ffmpeg_sources/ffmpeg || die
	eapply "${WORKDIR}"/build-deps/ffmpeg_patches/ffmpeg/*.patch

	# Copy ffmpeg sources because CBS build applies extra patches.
	cp -a ./ "${WORKDIR}"/ffmpeg-build || die

	cd "${S}" || die
	CMAKE_USE_DIR="${WORKDIR}/build-deps" cmake_src_prepare
	default_src_prepare() { :; } # Hack to avoid double patching! :(
	CMAKE_USE_DIR="${S}" cmake_src_prepare
}

src_configure() {
	local myconf=(
		--prefix="${S}"/third-party/ffmpeg
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--ar="$(tc-getAR)"
		--nm="$(tc-getNM)"
		--strip="$(tc-getSTRIP)"
		--ranlib="$(tc-getRANLIB)"
		--pkg-config="$(tc-getPKG_CONFIG)"
		--optflags="${CFLAGS}"
		--disable-all
		--disable-autodetect
		--disable-error-resilience
		--disable-everything
		--disable-faan
		--disable-iconv
		--disable-network
		--disable-optimizations
		--disable-stripping
		--enable-amf
		--enable-avcodec
		--enable-ffnvcodec
		--enable-gpl
		--enable-nvenc
		--enable-static
		--enable-swscale
		--enable-v4l2_m2m
		$(use_enable cuda)
		$(use_enable cuda cuda_llvm)
		$(use_enable svt-av1 libsvtav1)
		$(use_enable vaapi)
		$(use_enable x264 libx264)
		$(use_enable x265 libx265)
		$(usex svt-av1 --enable-encoder=libsvtav1 "")
		$(usex vaapi --enable-encoder=h264_vaapi,hevc_vaapi,av1_vaapi "")
		$(usex x264 --enable-encoder=libx264 "")
		$(usex x265 --enable-encoder=libx265 "")
		--enable-encoder=h264_amf,hevc_amf,av1_amf
		--enable-encoder=h264_nvenc,hevc_nvenc,av1_nvenc
		--enable-encoder=h264_v4l2m2m,hevc_v4l2m2m
	)

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

	cd "${WORKDIR}"/ffmpeg-build || die
	echo ./configure "${myconf[@]}"
	./configure "${myconf[@]}" || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DCMAKE_INSTALL_PREFIX="${S}"/third-party/ffmpeg
		$(usex arm64 -DCROSS_COMPILE_ARM=yes "")
		$(usex ppc64 -DCROSS_COMPILE_PPC=yes "")
	)
	CMAKE_USE_DIR="${WORKDIR}/build-deps" cmake_src_configure

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=yes
		-DFFMPEG_PLATFORM_LIBRARIES="$(usex svt-av1 SvtAv1Enc '');$(usex vaapi 'va;va-drm' '');$(usev x264);$(usev x265)"
		-DFFMPEG_PREPARED_BINARIES="${S}"/third-party/ffmpeg
		-DSUNSHINE_ASSETS_DIR=share/${PN}
		-DSUNSHINE_ENABLE_CUDA=$(usex cuda)
		-DSUNSHINE_ENABLE_DRM=$(usex libdrm)
		-DSUNSHINE_ENABLE_WAYLAND=$(usex wayland)
		-DSUNSHINE_ENABLE_X11=$(usex X)
		-DSUNSHINE_ENABLE_TRAY=$(usex trayicon)
		-DSUNSHINE_REQUIRE_TRAY=$(usex trayicon)
		-DSUNSHINE_SYSTEM_MINIUPNP=yes
		-DSUNSHINE_SYSTEM_WAYLAND_PROTOCOLS=yes
	)
	CMAKE_USE_DIR="${S}" cmake_src_configure
}

src_compile() {
	emake -C "${WORKDIR}"/ffmpeg-build V=1
	emake -C "${WORKDIR}"/ffmpeg-build V=1 install
	CMAKE_USE_DIR="${WORKDIR}/build-deps" cmake_src_compile
	CMAKE_USE_DIR="${WORKDIR}/build-deps" cmake_build install
	CMAKE_USE_DIR="${S}" npm_config_offline=1 cmake_src_compile
}

pkg_postinst() {
	udev_reload
	xdg_pkg_postinst
	use libdrm && fcaps cap_sys_admin+p usr/bin/"$(readlink "${EROOT}"/usr/bin/${PN})"

	elog "At upstream's request, please report any issues to https://bugs.gentoo.org"
	elog "rather than going directly to them."
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
}
