# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

CMAKE_BUILD_TYPE="None"
inherit cmake-utils python-single-r1 virtualx xdg-utils

DESCRIPTION="Toolkit that provides signal processing blocks to implement software radios"
HOMEPAGE="https://www.gnuradio.org/"
LICENSE="GPL-3"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/gnuradio/gnuradio.git"
	EGIT_BRANCH="pybind"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/gnuradio/gnuradio/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

IUSE="+audio +alsa +analog +digital channels doc dtv examples fec +filter grc jack modtool oss performance-counters portaudio +qt5 sdl test trellis uhd vocoder +utils wavelet zeromq"

#RESTRICT="!test? ( test )"
#Tests are known broken right now
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	audio? ( || ( alsa oss jack portaudio ) )
	alsa? ( audio )
	jack? ( audio )
	oss? ( audio )
	portaudio? ( audio )
	analog? ( filter )
	channels? ( filter analog qt5 )
	digital? ( filter analog )
	dtv? ( filter analog fec )
	modtool? ( utils )
	qt5? ( filter )
	trellis? ( analog digital )
	uhd? ( filter analog )
	vocoder? ( filter analog )
	wavelet? ( analog )
"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	>=dev-lang/orc-0.4.12
	$(python_gen_cond_dep 'dev-libs/boost:0=[python,${PYTHON_USEDEP}]')
	dev-libs/log4cpp
	$(python_gen_cond_dep 'dev-python/six[${PYTHON_USEDEP}]')
	sci-libs/fftw:3.0=
	sci-libs/mpir
	sci-libs/volk
	alsa? ( media-libs/alsa-lib:= )
	fec? (
		sci-libs/gsl
		sci-libs/scipy
	)
	filter? ( sci-libs/scipy )
	grc? (
		$(python_gen_cond_dep 'dev-python/mako[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]')
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-19_pre )
	qt5? (
		$(python_gen_cond_dep 'dev-python/PyQt5[opengl,${PYTHON_USEDEP}]')
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		x11-libs/qwt:6[qt5(+)]
		dev-qt/qtwidgets:5
	)
	sdl? ( >=media-libs/libsdl-1.2.0 )
	trellis? ( sci-libs/scipy )
	uhd? (
		$(python_gen_cond_dep '>=net-wireless/uhd-3.9.6:=[${PYTHON_SINGLE_USEDEP}]')
	)
	utils? (
		$(python_gen_cond_dep 'dev-python/click[${PYTHON_USEDEP}]
		dev-python/click-plugins[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]')
	)
	vocoder? (
		media-sound/gsm
		>=media-libs/codec2-0.8.1
	)
	wavelet? ( sci-libs/gsl
			dev-libs/gmp
			sci-libs/lapack
			)
	zeromq? ( >=net-libs/zeromq-2.1.11 )
"

#That's right, it can't build if gnuradio 3.7 is installed
#Both due to build failure, and then file collision due to bundled volk
DEPEND="${RDEPEND}
	!<net-wireless/gnuradio-3.8
	app-text/docbook-xml-dtd:4.2
	>=dev-lang/swig-3.0.5
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.5.7.1
	)
	grc? ( x11-misc/xdg-utils )
	oss? ( virtual/os-headers )
	test? ( >=dev-util/cppunit-1.9.14 )
	zeromq? ( net-libs/cppzmq )
"

src_prepare() {
	xdg_environment_reset #534582

	use !alsa && sed -i 's#version.h#version-nonexistent.h#' cmake/Modules/FindALSA.cmake
	use !jack && sed -i 's#jack.h#jack-nonexistent.h#' cmake/Modules/FindJACK.cmake
	use !oss && sed -i 's#soundcard.h#oss-nonexistent.h#g' cmake/Modules/FindOSS.cmake
	use !portaudio && sed -i 's#portaudio.h#portaudio-nonexistent.h#g' cmake/Modules/FindPORTAUDIO.cmake

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DENABLE_VOLK=OFF
		-DENABLE_GNURADIO_RUNTIME=ON
		-DENABLE_PYTHON=ON
		-DENABLE_GR_BLOCKS=ON
		-DENABLE_GR_FFT=ON
		-DENABLE_GR_AUDIO=ON
		-DENABLE_GR_ANALOG="$(usex analog)"
		-DENABLE_GR_CHANNELS="$(usex channels)"
		-DENABLE_GR_DIGITAL="$(usex digital)"
		-DENABLE_DOXYGEN="$(usex doc)"
		-DENABLE_GR_DTV="$(usex dtv)"
		-DENABLE_GR_FEC="$(usex fec)"
		-DENABLE_GR_FILTER="$(usex filter)"
		-DENABLE_GRC="$(usex grc)"
		-DENABLE_GR_MODTOOL="$(usex modtool)"
		-DENABLE_PERFORMANCE_COUNTERS="$(usex performance-counters)"
		-DENABLE_TESTING="$(usex test)"
		-DENABLE_GR_TRELLIS="$(usex trellis)"
		-DENABLE_GR_UHD="$(usex uhd)"
		-DENABLE_GR_UTILS="$(usex utils)"
		-DENABLE_GR_VOCODER="$(usex vocoder)"
		-DENABLE_GR_WAVELET="$(usex wavelet)"
		-DENABLE_GR_QTGUI="$(usex qt5)"
		-DENABLE_GR_VIDEO_SDL="$(usex sdl)"
		-DENABLE_GR_ZEROMQ="$(usex zeromq)"
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PYTHON_DIR="$(python_get_sitedir)"
		-DGR_PKG_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		dodir /usr/share/doc/${PF}/
		mv "${ED}"/usr/share/${PN}/examples "${ED}"/usr/share/doc/${PF}/ || die
		docompress -x /usr/share/doc/${PF}/examples
	else
	# It seems that the examples are always installed
		rm -rf "${ED}"/usr/share/${PN}/examples || die
	fi

	if use doc || use examples; then
		#this doesn't appear useful
		rm -rf "${ED}"/usr/share/doc/${PF}/xml || die
	fi

	# Remove duplicated icons, MIME and desktop files and installation script
	rm -rf "${ED}"/usr/share/${PN}/grc/freedesktop || die
	rm -f "${ED}"/usr/libexec/${PN}/grc_setup_freedesktop || die

	# Install icons, menu items and mime-types for GRC
	if use grc ; then
		local fd_path="${S}/grc/scripts/freedesktop"
		insinto /usr/share/mime/packages
		doins "${fd_path}/${PN}-grc.xml"

		domenu "${fd_path}/"*.desktop
		doicon "${fd_path}/"*.png
	fi

	python_fix_shebang "${ED}"
	# Remove incorrectly byte-compiled Python files and replace
	find "${ED}"/usr/lib -name "*.py[co]" -exec rm {} \; || die
	python_optimize
}

src_test()
{
	virtx cmake-utils_src_test
}

pkg_postinst()
{
	if use grc ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}

pkg_postrm()
{
	if use grc ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}
