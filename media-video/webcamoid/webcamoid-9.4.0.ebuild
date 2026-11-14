# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs xdg

DESCRIPTION="Full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
if [[ ${PV} == *9999* ]]; then
	EGIT_SUBMODULES=(
		-"libAvKys/ExtraPlugins" # git@github.com:webcamoid_WebcamoidPrivate.git
	)
	EGIT_REPO_URI="https://github.com/webcamoid/webcamoid.git"
	inherit git-r3
else
	SRC_URI="https://github.com/webcamoid/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

CPU_FLAGS=(
	cpu_flags_arm_{neon,sve}
	#cpu_flags_riscv_rvv
	cpu_flags_x86_{mmx,sse,sse2,sse4_1,avx,avx2}
)

IUSE="${CPU_FLAGS[@]} alsa debug +ffmpeg libusb libuvc openmp pipewire portaudio
	pulseaudio qtcamera qtscreen screencast v4l wayland X"

REQUIRED_USE="screencast? ( ffmpeg )"

COMMON_DEPEND="
	sys-apps/kmod
	dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	libusb? ( dev-libs/libusb:1 )
	libuvc? ( >=media-libs/libuvc-0.0.7 )
	pipewire? ( media-video/pipewire:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	v4l? ( media-libs/libv4l )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
	)
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXfixes
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.6
"
RDEPEND="${COMMON_DEPEND}
	virtual/opengl
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/927104
	# https://github.com/webcamoid/webcamoid/issues/702
	# filter-lto is no longer required to complete the build with -Werror=odr
	# since the upstream commit d28f0faf8d107e9d613394a6090ea17f0c9db668

	#Disable git in package source. If not disabled the cmake configure process will show
	#a lot of "fatal not a git repository" errors
	sed -i 's|find_program(GIT_BIN git)|#find_program(GIT_BIN git)|' libAvKys/cmake/ProjectCommons.cmake || die

	local mycmakeargs=(
		-DENABLE_IPO=0 # LTO/IPO should be controlled via user-flags
		-DNOVIDEOEFFECTS=0 # no extra deps, no IUSE
		-DNOCHECKUPDATES=1
		-DNOMEDIAFOUNDATION=1
		-DNODSHOW=1
		-DNOWASAPI=1
		-DNOSCREENCAPTURE=0 # screen capturing via pipewire, qtscreen, screencast, wayland, or X
		-DNOALSA=$(usex !alsa)
		-DNOFFMPEG=$(usex !ffmpeg)
		-DNOLIBUSB=$(usex !libusb)
		-DNOLIBUVC=$(usex !libuvc)
		-DNOOPENMP=$(usex !openmp)
		-DNOPIPEWIRE=$(usex !pipewire)
		-DNOPORTAUDIO=$(usex !portaudio)
		-DNOPULSEAUDIO=$(usex !pulseaudio)
		-DNOQTCAMERA=$(usex !qtcamera)
		-DNOQTSCREENCAPTURE=$(usex !qtscreen)
		-DNOFFMPEGSCREENCAP=$(usex !screencast)
		-DNOV4L2=$(usex !v4l)
		-DNOV4LUTILS=$(usex !v4l)
		-DNOWLROOTS=$(usex !wayland)
		-DNOXLIBSCREENCAP=$(usex !X)
		-DNOSIMDNEON=$(usex !cpu_flags_arm_neon)
		-DNOSIMDSVE=$(usex !cpu_flags_arm_sve)
		#-DNOSIMDRVV=$(usex !cpu_flags_riscv_rvv)
		-DNOSIMDMMX=$(usex !cpu_flags_x86_mmx)
		-DNOSIMDSSE=$(usex !cpu_flags_x86_sse)
		-DNOSIMDSSE2=$(usex !cpu_flags_x86_sse2)
		-DNOSIMDSSE4_1=$(usex !cpu_flags_x86_sse4_1)
		-DNOSIMDAVX=$(usex !cpu_flags_x86_avx)
		-DNOSIMDAVX2=$(usex !cpu_flags_x86_avx2)
	)

	# Control QML debugging with the 'debug' USE flag #981081
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release) cmake_src_configure
}

src_install() {
	docompress -x /usr/share/man/man1/${PN}.1.gz
	cmake_src_install
}
