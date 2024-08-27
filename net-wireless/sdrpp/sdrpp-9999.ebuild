# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="Runtime dependencies for SDRPlusPlus"
HOMEPAGE="
	https://www.sdrpp.org/
	https://github.com/AlexandreRouma/SDRPlusPlus/
	"

LICENSE="GPL-3"
SLOT=0
IUSE="+airspy atv +audio-sink +audio-src badgesdr +bladerf falcon9 +hackrf +hermes +limesdr +m17 pager +plutosdr portaudio-sink +portaudio-new-sink +rtlsdr ryfi +sched +sdrplay soapysdr uhd wsat"
PATCHES=(
	"${FILESDIR}/${PN}-multilib-strict.patch"
)

EGIT_REPO_URI="https://github.com/AlexandreRouma/SDRPlusPlus/"
EGIT_BRANCH=master

REQUIRED_USE="
	audio-sink? ( !portaudio-sink )
"
BDEPEND="dev-build/cmake"
RDEPEND="
	sci-libs/fftw:3.0
	sci-libs/volk
	app-arch/zstd
	media-libs/glfw
	airspy? ( net-wireless/airspy )
	audio-src? ( media-libs/rtaudio )
	audio-sink? ( media-libs/rtaudio )
	badgesdr? ( virtual/libusb )
	bladerf? (
			net-wireless/bladerf
			net-wireless/bladerf-firmware
			net-wireless/bladerf-fpga
		)
	falcon9? ( media-video/ffmpeg )
	hackrf? ( net-libs/libhackrf )
	limesdr? ( net-wireless/limesuite )
	m17? ( media-libs/codec2 )
	plutosdr? (
			net-libs/libiio
			net-libs/libad9361-iio
		)
	portaudio-sink? ( media-libs/portaudio )
	portaudio-new-sink? ( media-libs/portaudio )
	rtlsdr? ( virtual/rtl-sdr-drivers )
	sdrplay? ( net-wireless/sdrplay )
	soapysdr? ( net-wireless/soapysdr )
	uhd? ( net-wireless/uhd )
"

src_configure() {
	if use falcon9 ; then
		ewarn "Falcon9 decoder support is incomplete/experimental and may not compile or run properly.  Disable falcon9 USE flag to disable."
	fi
	if use wsat ; then
		ewarn "WeatherSat decoder support is incomplete/experimental and may not compile or run properly.  Disable wsat USE flag to disable."
	fi
	local mycmakeargs=(
		-DOPT_BACKEND_GLFW=ON

		-DOPT_BUILD_AIRSPY_SOURCE=$(usex airspy ON OFF)
		-DOPT_BUILD_AIRSPYHF_SOURCE=OFF
		-DOPT_BUILD_AUDIO_SOURCE=$(usex audio-src ON OFF)
		-DOPT_BUILD_BADGESDR_SOURCE=$(usex badgesdr ON OFF)
		-DOPT_BUILD_BLADERF_SOURCE=$(usex bladerf ON OFF)
		-DOPT_BUILD_FILE_SOURCE=ON
		-DOPT_BUILD_HACKRF_SOURCE=$(usex hackrf ON OFF)
		-DOPT_BUILD_HAROGIC_SOURCE=OFF
		-DOPT_BUILD_HERMES_SOURCE=$(usex hermes ON OFF)
		-DOPT_BUILD_LIMESDR_SOURCE=$(usex limesdr ON OFF)
		-DOPT_BUILD_NETWORK_SOURCE=ON
		-DOPT_BUILD_PERSEUS_SOURCE=OFF
		-DOPT_BUILD_PLUTOSDR_SOURCE=$(usex plutosdr ON OFF)
		-DOPT_BUILD_RFNM_SOURCE=OFF
		-DOPT_BUILD_RFSPACE_SOURCE=ON
		-DOPT_BUILD_RTL_SDR_SOURCE=$(usex rtlsdr ON OFF)
		-DOPT_BUILD_RTL_TCP_SOURCE=ON
		-DOPT_BUILD_SDRPLAY_SOURCE=$(usex sdrplay ON OFF)
		-DOPT_BUILD_SDRPP_SERVER_SOURCE=ON
		-DOPT_BUILD_SOAPY_SOURCE=$(usex soapysdr ON OFF)
		-DOPT_BUILD_SPECTRAN_SOURCE=OFF
		-DOPT_BUILD_SPECTRAN_HTTP_SOURCE=ON
		-DOPT_BUILD_SPYSERVER_SOURCE=ON
		-DOPT_BUILD_USRP_SOURCE=$(usex uhd ON OFF)

		-DOPT_BUILD_ANDROID_AUDIO_SINK=OFF
		-DOPT_BUILD_AUDIO_SINK=$(usex audio-sink ON OFF)
		-DOPT_BUILD_NETWORK_SINK=ON
		-DOPT_BUILD_NEW_PORTAUDIO_SINK=$(usex portaudio-new-sink ON OFF)
		-DOPT_BUILD_PORTAUDIO_SINK=$(usex portaudio-sink ON OFF)

		-DOPT_BUILD_ATV_DECODER=$(usex atv ON OFF)
		-DOPT_BUILD_FALCON9_DECODER=$(usex falcon9 ON OFF)
		-DOPT_BUILD_KG_SSTV_DECODER=OFF
		-DOPT_BUILD_M17_DECODER=$(usex m17 ON OFF)
		-DOPT_BUILD_METEOR_DEMODULATOR=ON
		-DOPT_BUILD_PAGER_DECODER=$(usex pager ON OFF)
		-DOPT_BUILD_RADIO=ON
		-DOPT_BUILD_RYFI_DECODER=$(usex ryfi ON OFF)
		-DOPT_BUILD_WEATHER_SAT_DECODER=$(usex wsat ON OFF)

		-DOPT_BUILD_DISCORD_PRESENCE=OFF
		-DOPT_BUILD_FREQUENCY_MANAGER=ON
		-DOPT_BUILD_IQ_EXPORTER=ON
		-DOPT_BUILD_RECORDER=ON
		-DOPT_BUILD_RIGCTL_CLIENT=ON
		-DOPT_BUILD_RIGCTL_SERVER=ON
		-DOPT_BUILD_SCANNER=ON
		-DOPT_BUILD_SCHEDULER=$(usex sched ON OFF)

		-DUSE_INTERNAL_LIBCORRECT=ON
		-DUSE_BUNDLE_DEFAULTS=OFF
		-DCOPY_MSVC_REDISTRIBUTABLES=OFF
	)
	cmake_src_configure
}
