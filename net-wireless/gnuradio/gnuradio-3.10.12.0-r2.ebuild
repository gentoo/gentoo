# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
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
	KEYWORDS="amd64 ~arm ~riscv ~x86"
fi

IUSE="+audio +alsa +analog +digital channels ctrlport doc dtv examples fec +filter grc iio jack modtool network oss performance-counters portaudio +qt5 sdl soapy test trellis uhd vocoder +utils wavelet zeromq"

#RESTRICT="!test? ( test )"
# Tests are pulling in the installed python libs and breaking
# https://github.com/gnuradio/gnuradio/issues/7568
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alsa? ( audio )
	analog? ( filter )
	audio? ( || ( alsa oss jack portaudio ) )
	channels? ( filter analog qt5 )
	digital? ( filter analog )
	dtv? ( filter analog fec )
	jack? ( audio )
	modtool? ( utils )
	oss? ( audio )
	portaudio? ( audio )
	qt5? ( filter )
	test? ( channels )
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
		$(python_gen_cond_dep 'dev-python/scipy[${PYTHON_USEDEP}]')
	)
	filter? (
		$(python_gen_cond_dep 'dev-python/scipy[${PYTHON_USEDEP}]')
		qt5? ( $(python_gen_cond_dep 'dev-python/pyqtgraph[qt5,${PYTHON_USEDEP}]') )
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
	)
	jack? ( virtual/jack )
	portaudio? ( >=media-libs/portaudio-19_pre )
	qt5? (
		$(python_gen_cond_dep 'dev-python/pyqt5[opengl,${PYTHON_USEDEP}]')
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		x11-libs/qwt:6=[qt5(-)]
		dev-qt/qtwidgets:5
	)
	soapy? (
		net-wireless/soapysdr:=[${PYTHON_SINGLE_USEDEP}]
	)
	sdl? ( >=media-libs/libsdl-1.2.0 )
	trellis? ( dev-python/scipy )
	uhd? (
		>=net-wireless/uhd-3.9.6:=[${PYTHON_SINGLE_USEDEP}]
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
	test? (
		>=dev-util/cppunit-1.9.14
		dev-python/pyzmq
	)
	zeromq? ( net-libs/cppzmq )
"

PATCHES=( "${FILESDIR}/${P}-boost-1.89.patch" ) # bug 969063

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
		-DENABLE_GR_ANALOG="$(usex analog ON OFF)"
		-DENABLE_GR_AUDIO=ON
		-DENABLE_GR_CHANNELS="$(usex channels ON OFF)"
		-DENABLE_GR_CTRLPORT="$(usex ctrlport ON OFF)"
		-DENABLE_GR_DIGITAL="$(usex digital ON OFF)"
		-DENABLE_DOXYGEN="$(usex doc ON OFF)"
		-DENABLE_GR_DTV="$(usex dtv ON OFF)"
		-DENABLE_GR_FEC="$(usex fec ON OFF)"
		-DENABLE_GR_FFT=ON
		-DENABLE_GR_FILTER="$(usex filter ON OFF)"
		-DENABLE_GRC="$(usex grc ON OFF)"
		-DENABLE_GR_IIO="$(usex iio ON OFF)"
		-DENABLE_GR_MODTOOL="$(usex modtool ON OFF)"
		-DENABLE_GR_BLOCKTOOL="$(usex modtool ON OFF)"
		-DENABLE_GR_NETWORK="$(usex network ON OFF)"
		-DENABLE_GR_PDU=ON
		-DENABLE_PERFORMANCE_COUNTERS="$(usex performance-counters ON OFF)"
		-DENABLE_TESTING="$(usex test ON OFF)"
		-DENABLE_GR_QTGUI="$(usex qt5 ON OFF)"
		-DENABLE_GR_SOAPY="$(usex soapy ON OFF)"
		-DENABLE_GR_TRELLIS="$(usex trellis ON OFF)"
		-DENABLE_GR_UHD="$(usex uhd ON OFF)"
		-DENABLE_GR_UTILS="$(usex utils ON OFF)"
		-DENABLE_GR_VIDEO_SDL="$(usex sdl ON OFF)"
		-DENABLE_GR_VOCODER="$(usex vocoder ON OFF)"
		-DENABLE_GR_WAVELET="$(usex wavelet ON OFF)"
		-DENABLE_GR_ZEROMQ="$(usex zeromq ON OFF)"
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PYTHON_DIR="$(python_get_sitedir)"
		-DGR_PKG_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DMATHJAX2_ROOT="${EPREFIX}/usr/share/mathjax"
	)
	# replace -DSYSCONFDIR in 3.10.13.0
	#-DGR_CONF_DIR="${EPREFIX}"/etc
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
	# skip test which needs internet (metainfo_test)
	virtx cmake_src_test -E 'metainfo_test' --output-on-failure
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
