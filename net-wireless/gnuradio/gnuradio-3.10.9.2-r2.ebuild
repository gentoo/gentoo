# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

CMAKE_BUILD_TYPE="None"
inherit cmake desktop python-single-r1 virtualx xdg-utils

DESCRIPTION="Toolkit that provides signal processing blocks to implement software radios"
HOMEPAGE="https://www.gnuradio.org/"
LICENSE="GPL-3"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/gnuradio/gnuradio.git"
	EGIT_BRANCH="maint-3.10"
	inherit git-r3
else
	SRC_URI="https://github.com/gnuradio/gnuradio/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

IUSE="+audio +alsa +analog +digital channels ctrlport doc dtv examples fec +filter grc iio jack modtool network oss performance-counters portaudio +qt5 sdl soapy test trellis uhd vocoder +utils wavelet zeromq"

RESTRICT="!test? ( test )"

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
	$(python_gen_cond_dep 'dev-libs/boost:=[python,${PYTHON_USEDEP}]')
	dev-libs/gmp:=
	dev-libs/log4cpp:=
	$(python_gen_cond_dep 'dev-python/jsonschema[${PYTHON_USEDEP}]')
	dev-libs/spdlog:=
	dev-libs/libfmt:=
	sci-libs/fftw:3.0=
	sci-libs/volk:=
	media-libs/libsndfile
	sys-libs/libunwind
	alsa? ( media-libs/alsa-lib:= )
	ctrlport? (
		$(python_gen_cond_dep 'dev-python/thrift[${PYTHON_USEDEP}]')
	)
	fec? (
		sci-libs/gsl:=
		dev-python/scipy
	)
	filter? (
		dev-python/scipy
		$(python_gen_cond_dep 'dev-python/pyqtgraph[${PYTHON_USEDEP}]')
	)
	grc? (
		$(python_gen_cond_dep 'dev-python/mako[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]')
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
	iio? (
		net-libs/libiio:=
		net-libs/libad9361-iio:=
		!net-wireless/gr-iio
	)
	jack? ( virtual/jack )
	portaudio? ( >=media-libs/portaudio-19_pre )
	qt5? (
		$(python_gen_cond_dep 'dev-python/PyQt5[opengl,${PYTHON_USEDEP}]')
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		x11-libs/qwt:6=[qt5(+)]
		dev-qt/qtwidgets:5
	)
	soapy? (
		$(python_gen_cond_dep 'net-wireless/soapysdr:=[${PYTHON_USEDEP}]')
	)
	sdl? ( >=media-libs/libsdl-1.2.0 )
	trellis? ( dev-python/scipy )
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
		>=media-libs/codec2-0.8.1:=
	)
	wavelet? (
		sci-libs/gsl:=
		sci-libs/lapack
	)
	zeromq? ( >=net-libs/zeromq-2.1.11:= )
"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.5.7.1
		<dev-libs/mathjax-3
	)
	grc? ( x11-misc/xdg-utils )
	modtool? ( $(python_gen_cond_dep 'dev-python/pygccxml[${PYTHON_USEDEP}]') )
	oss? ( virtual/os-headers )
	test? ( >=dev-util/cppunit-1.9.14 )
	zeromq? ( net-libs/cppzmq )
"

PATCHES=( "${FILESDIR}/PR7093.patch" )

src_prepare() {
	xdg_environment_reset #534582

	use !alsa && sed -i 's#version.h#version-nonexistent.h#' cmake/Modules/FindALSA.cmake
	use !jack && sed -i 's#jack.h#jack-nonexistent.h#' cmake/Modules/FindJACK.cmake
	use !oss && sed -i 's#soundcard.h#oss-nonexistent.h#g' cmake/Modules/FindOSS.cmake
	use !portaudio && sed -i 's#portaudio.h#portaudio-nonexistent.h#g' cmake/Modules/FindPORTAUDIO.cmake

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DENABLE_GNURADIO_RUNTIME=ON
		-DENABLE_PYTHON=ON
		-DENABLE_GR_BLOCKS=ON
		-DENABLE_GR_ANALOG="$(usex analog)"
		-DENABLE_GR_AUDIO=ON
		-DENABLE_GR_CHANNELS="$(usex channels)"
		-DENABLE_GR_CTRLPORT="$(usex ctrlport)"
		-DENABLE_GR_DIGITAL="$(usex digital)"
		-DENABLE_DOXYGEN="$(usex doc)"
		-DENABLE_GR_DTV="$(usex dtv)"
		-DENABLE_GR_FEC="$(usex fec)"
		-DENABLE_GR_FFT=ON
		-DENABLE_GR_FILTER="$(usex filter)"
		-DENABLE_GRC="$(usex grc)"
		-DENABLE_GR_IIO="$(usex iio)"
		-DENABLE_GR_MODTOOL="$(usex modtool)"
		-DENABLE_GR_BLOCKTOOL="$(usex modtool)"
		-DENABLE_GR_NETWORK="$(usex network)"
		-DENABLE_GR_PDU=ON
		-DENABLE_PERFORMANCE_COUNTERS="$(usex performance-counters)"
		-DENABLE_TESTING="$(usex test)"
		-DENABLE_GR_QTGUI="$(usex qt5)"
		-DENABLE_GR_SOAPY="$(usex soapy)"
		-DENABLE_GR_TRELLIS="$(usex trellis)"
		-DENABLE_GR_UHD="$(usex uhd)"
		-DENABLE_GR_UTILS="$(usex utils)"
		-DENABLE_GR_VIDEO_SDL="$(usex sdl)"
		-DENABLE_GR_VOCODER="$(usex vocoder)"
		-DENABLE_GR_WAVELET="$(usex wavelet)"
		-DENABLE_GR_ZEROMQ="$(usex zeromq)"
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PYTHON_DIR="$(python_get_sitedir)"
		-DGR_PKG_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DMATHJAX2_ROOT="${EPREFIX}/usr/share/mathjax"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

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

		domenu "${fd_path}/${PN}-grc.desktop"
		for size in 16 24 32 48 64 128 256; do
			newicon -s $size "${fd_path}/"grc-icon-$size.png ${PN}-grc.png
		done
	fi

	python_fix_shebang "${ED}"
	# Remove incorrectly byte-compiled Python files and replace
	find "${ED}"/usr/lib* -name "*.py[co]" -exec rm {} \; || die
	python_optimize
}

src_test() {
	# skip test which needs internet
	virtx cmake_src_test -E metainfo_test --output-on-failure
}

pkg_postinst() {
	if use grc ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}

pkg_postrm() {
	if use grc ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
	fi
}
