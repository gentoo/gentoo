# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.10
inherit ecm optfeature toolchain-funcs xdg

DESCRIPTION="Limiter, auto volume and many other plugins for PipeWire applications"
HOMEPAGE="https://github.com/wwmm/easyeffects"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wwmm/easyeffects"
else
	SRC_URI="https://github.com/wwmm/easyeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

# No real tests. ECM brings appstream test which isn't relevant downstream.
RESTRICT="test"

RDEPEND="
	dev-cpp/nlohmann_json
	dev-cpp/tbb:=
	dev-libs/glib:2
	dev-libs/kirigami-addons:6
	dev-libs/libportal:=[qt6]
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtgraphs:6
	kde-frameworks/kconfig:6
	kde-frameworks/kconfigwidgets:6
	kde-frameworks/kcoreaddons:6
	kde-frameworks/ki18n:6
	kde-frameworks/kiconthemes:6
	kde-frameworks/kirigami:6
	kde-frameworks/qqc2-desktop-style:6
	media-libs/libbs2b
	>=media-libs/libebur128-1.2.6:=
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	>=media-libs/lilv-0.24
	media-libs/rnnoise
	media-libs/speexdsp
	media-libs/webrtc-audio-processing:2
	>=media-libs/zita-convolver-3.0.0:=
	>=media-video/pipewire-1.0.6:=[sound-server]
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
"
BDEPEND="
	dev-libs/appstream
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if ! tc-is-gcc; then
			if ! tc-is-clang || [[ $(clang-major-version) -lt 16 ]]; then
				die "${PN} can only be built with GCC or >=Clang-16 due to required level of C++20 support"
			fi
		elif [[ $(gcc-major-version) -lt 11 ]] ; then
			die "Since version 6.2.5, ${PN} requires GCC 11 or newer to build (bug #848072)"
		fi
	fi
}

src_configure() {
	local libcxx=false
	[[ $(tc-get-cxx-stdlib) == "libc++" ]] && libcxx=true

	local mycmakeargs=(
		-DENABLE_LIBCPP_WORKAROUNDS=${libcxx}
	)

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Install optional audio plugins:"
	optfeature "limiter, exciter, bass enhancer and others" media-plugins/calf
	optfeature "equalizer, compressor, delay, loudness" media-libs/lsp-plugins
	optfeature "maximizer" media-plugins/zam-plugins
	optfeature "bass loudness" media-plugins/mda-lv2
	optfeature "noise remover (available in GURU overlay)" media-sound/deep-filter[ladspa]
}
