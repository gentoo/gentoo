# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

CMAKE_BUILD_TYPE="None"
inherit cmake-utils eutils gnome2-utils python-single-r1 python-utils-r1 xdg-utils

DESCRIPTION="Toolkit that provides signal processing blocks to implement software radios"
HOMEPAGE="https://www.gnuradio.org/"
LICENSE="GPL-3"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://www.gnuradio.org/cgit/gnuradio.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://www.gnuradio.org/releases/gnuradio/${P}.tar.gz
		https://dev.gentoo.org/~zerochaos/patches/${PN}-3.7.13-1-qt5.tar.xz
		https://dev.gentoo.org/~zerochaos/patches/${PN}-3.7.13-codec2.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi
if [[ ${PV} == "3.7.9999" ]]; then
	EGIT_BRANCH="maint"
elif [[ ${PV} == "3.8.9999" ]]; then
	EGIT_BRANCH="next"
fi

IUSE="+audio +alsa atsc +analog +digital channels doc dtv examples fcd fec +filter grc jack log noaa oss pager performance-counters portaudio +qt5 sdl test trellis uhd vocoder +utils wavelet wxwidgets zeromq"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
		audio? ( || ( alsa oss jack portaudio ) )
		alsa? ( audio )
		oss? ( audio )
		jack? ( audio )
		portaudio? ( audio )
		analog? ( filter )
		digital? ( filter analog )
		dtv? ( fec )
		pager? ( filter analog )
		qt5? ( filter )
		uhd? ( filter analog )
		fcd? ( || ( alsa oss ) )
		wavelet? ( analog )
		wxwidgets? ( filter analog )"

# bug #348206
# comedi? ( >=sci-electronics/comedilib-0.8 )
# boost-1.52.0 is blacklisted, bug #461578, upstream #513, boost #7669
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/orc-0.4.12
	dev-libs/boost:0=[${PYTHON_USEDEP}]
	!<=dev-libs/boost-1.52.0-r6:0/1.52
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/fftw:3.0=
	alsa? (
		media-libs/alsa-lib:=
	)
	fcd? ( virtual/libusb:1 )
	filter? ( sci-libs/scipy )
	grc? (
		dev-python/pygobject:*[cairo(+),${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
	)
	jack? (
		media-sound/jack-audio-connection-kit
	)
	log? ( dev-libs/log4cpp )
	portaudio? (
		>=media-libs/portaudio-19_pre
	)
	qt5? (
		dev-python/PyQt5[opengl,${PYTHON_USEDEP}]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		x11-libs/qwt:6[qt5(+)]
		dev-qt/qtwidgets:5
	)
	sdl? ( >=media-libs/libsdl-1.2.0 )
	uhd? ( >=net-wireless/uhd-3.9.6:=[${PYTHON_USEDEP}] )
	utils? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	vocoder? ( media-sound/gsm
		 >=media-libs/codec2-0.8.1 )
	wavelet? (
		>=sci-libs/gsl-1.10
	)
	wxwidgets? (
		dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	)
	zeromq? ( >=net-libs/zeromq-2.1.11 )
	"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	>=dev-lang/swig-3.0.5
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.5.7.1
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	grc? ( x11-misc/xdg-utils )
	oss? ( virtual/os-headers )
	test? ( >=dev-util/cppunit-1.9.14 )
	zeromq? ( net-libs/cppzmq )
"

src_prepare() {
	gnome2_environment_reset #534582

	if [[ ${PV} == "3.8.9999" ]]; then
		true
	else
		epatch "${FILESDIR}"/gnuradio-wxpy3.0-compat.patch
	fi
	# Useless UI element would require qt3support, bug #365019
	sed -i '/qPixmapFromMimeSource/d' "${S}"/gr-qtgui/lib/spectrumdisplayform.ui || die
	epatch "${WORKDIR}"/qt5-maint-00*.patch
	epatch "${WORKDIR}"/codec2-next-00*.patch

	cmake-utils_src_prepare
}

src_configure() {
	python_export PYTHON_SITEDIR
	mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DENABLE_GNURADIO_RUNTIME=ON
		-DENABLE_VOLK=ON
		-DENABLE_PYTHON=ON
		-DENABLE_GR_BLOCKS=ON
		-DENABLE_GR_FFT=ON
		-DENABLE_GR_AUDIO=ON
		-DENABLE_GR_AUDIO_ALSA="$(usex alsa)"
		-DENABLE_GR_ANALOG="$(usex analog)"
		-DENABLE_GR_ATSC="$(usex atsc)"
		-DENABLE_GR_CHANNELS="$(usex channels)"
		-DENABLE_GR_DIGITAL="$(usex digital)"
		-DENABLE_DOXYGEN="$(usex doc)"
		-DENABLE_SPHINX="$(usex doc)"
		-DENABLE_GR_DTV="$(usex dtv)"
		-DENABLE_GR_FCD="$(usex fcd)"
		-DENABLE_GR_FEC="$(usex fec)"
		-DENABLE_GR_FILTER="$(usex filter)"
		-DENABLE_GRC="$(usex grc)"
		-DENABLE_GR_AUDIO_JACK="$(usex jack)"
		-DENABLE_GR_LOG="$(usex log)"
		-DENABLE_GR_NOAA="$(usex noaa)"
		-DENABLE_GR_AUDIO_OSS="$(usex oss)"
		-DENABLE_GR_PAGER="$(usex pager)"
		-DENABLE_ENABLE_PERFORMANCE_COUNTERS="$(usex performance-counters)"
		-DENABLE_GR_AUDIO_PORTAUDIO="$(usex portaudio)"
		-DENABLE_TESTING="$(usex test)"
		-DENABLE_GR_TRELLIS="$(usex trellis)"
		-DENABLE_GR_UHD="$(usex uhd)"
		-DENABLE_GR_UTILS="$(usex utils)"
		-DENABLE_GR_VOCODER="$(usex vocoder)"
		-DENABLE_GR_WAVELET="$(usex wavelet)"
		-DENABLE_GR_WXGUI="$(usex wxwidgets)"
		-DENABLE_GR_QTGUI="$(usex qt5)"
		-DDESIRED_QT_VERSION="$(usex qt5 5)"
		-DENABLE_GR_VIDEO_SDL="$(usex sdl)"
		-DENABLE_GR_ZEROMQ="$(usex zeromq)"
		-DENABLE_GR_CORE=ON
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PYTHON_DIR="${PYTHON_SITEDIR}"
		-DGR_PKG_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
	)
	use vocoder && mycmakeargs+=( -DGR_USE_SYSTEM_LIBGSM=TRUE )
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

	# We install the mimetypes to the correct locations from the ebuild
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
}

src_test()
{
	ctest -E qtgui
}

pkg_postinst()
{
	local GRC_ICON_SIZES="32 48 64 128 256"

	if use grc ; then
		xdg_desktop_database_update
		xdg_mime_database_update
		for size in ${GRC_ICON_SIZES} ; do
			xdg-icon-resource install --noupdate --context mimetypes --size ${size} \
				"${EROOT}/usr/share/pixmaps/grc-icon-${size}.png" application-gnuradio-grc \
				|| die "icon resource installation failed"
			xdg-icon-resource install --noupdate --context apps --size ${size} \
				"${EROOT}/usr/share/pixmaps/grc-icon-${size}.png" gnuradio-grc \
				|| die "icon resource installation failed"
		done
		xdg-icon-resource forceupdate
	fi
}

pkg_postrm()
{
	local GRC_ICON_SIZES="32 48 64 128 256"

	if use grc ; then
		xdg_desktop_database_update
		xdg_mime_database_update
		for size in ${GRC_ICON_SIZES} ; do
			xdg-icon-resource uninstall --noupdate --context mimetypes --size ${size} \
				application-gnuradio-grc || ewarn "icon uninstall failed"
			xdg-icon-resource uninstall --noupdate --context apps --size ${size} \
				gnuradio-grc || ewarn "icon uninstall failed"

		done
		xdg-icon-resource forceupdate
	fi
}
