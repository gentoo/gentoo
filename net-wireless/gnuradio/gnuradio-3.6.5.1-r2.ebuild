# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils fdo-mime python-single-r1

DESCRIPTION="Toolkit that provides signal processing blocks to implement software radios"
HOMEPAGE="http://gnuradio.org/"
LICENSE="GPL-3"
SLOT="0/${PV}"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="http://gnuradio.org/git/gnuradio.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="http://gnuradio.org/releases/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

IUSE="alsa +analog +digital doc examples fcd +filter grc jack oss pager performance-counters portaudio qt4 sdl uhd +utils wavelet"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
		analog? ( filter )
		digital? ( filter analog )
		pager? ( filter analog )
		qt4? ( filter )
		uhd? ( filter analog )
		fcd? ( || ( alsa oss ) )
		wavelet? ( analog )"

# bug #348206
# comedi? ( >=sci-electronics/comedilib-0.7 )
# boost-1.52.0 is blacklisted, bug #461578, upstream #513, boost #7669
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/orc-0.4.12
	dev-libs/boost:0=[${PYTHON_USEDEP}]
	!<=dev-libs/boost-1.52.0-r6:0/1.52
	dev-util/cppunit
	sci-libs/fftw:3.0=
	fcd? ( virtual/libusb:1 )
	alsa? (
		media-libs/alsa-lib[${PYTHON_USEDEP}]
	)
	grc? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)
	jack? (
		media-sound/jack-audio-connection-kit
	)
	portaudio? (
		>=media-libs/portaudio-19_pre
	)
	qt4? (
		dev-python/PyQt4[X,opengl,${PYTHON_USEDEP}]
		dev-python/pyqwt:5
		dev-qt/qtgui:4
	)
	sdl? ( media-libs/libsdl )
	uhd? ( >=net-wireless/uhd-3.4.3-r1:=[${PYTHON_USEDEP}] )
	wavelet? (
		sci-libs/gsl
	)
"
DEPEND="${RDEPEND}
	dev-lang/swig
	dev-python/cheetah[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.5.7.1
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	grc? (
		x11-misc/xdg-utils
	)
	oss? (
		virtual/os-headers
	)
"

src_prepare() {
	# Useless UI element would require qt3support, bug #365019
	sed -i '/qPixmapFromMimeSource/d' "${S}"/gr-qtgui/lib/spectrumdisplayform.ui || die
	epatch "${FILESDIR}"/${PN}-3.6.1-automagic-audio.patch
}

src_configure() {
	# TODO: docs are installed to /usr/share/doc/${PN} not /usr/share/doc/${PF}
	# SYSCONFDIR/GR_PREFSDIR default to install below CMAKE_INSTALL_PREFIX
	mycmakeargs=(
		$(cmake-utils_use_enable alsa GR_AUDIO_ALSA) \
		$(cmake-utils_use_enable analog GR_ANALOG) \
		$(cmake-utils_use_enable digital GR_DIGITAL) \
		$(cmake-utils_use_enable doc DOXYGEN) \
		$(cmake-utils_use_enable doc SPHINX) \
		$(cmake-utils_use_enable fcd GR_FCD) \
		$(cmake-utils_use_enable filter GR_FILTER) \
		$(cmake-utils_use_enable grc GRC) \
		$(cmake-utils_use_enable jack GR_AUDIO_JACK) \
		$(cmake-utils_use_enable oss GR_AUDIO_OSS) \
		$(cmake-utils_use_enable pager GR_PAGER) \
		$(cmake-utils_use_enable performance-counters ENABLE_PERFORMANCE_COUNTERS) \
		$(cmake-utils_use_enable portaudio GR_AUDIO_PORTAUDIO) \
		$(cmake-utils_use_enable uhd GR_UHD) \
		$(cmake-utils_use_enable utils GR_UTILS) \
		$(cmake-utils_use_enable wavelet GR_WAVELET) \
		$(cmake-utils_use_enable qt4 GR_QTGUI) \
		$(cmake-utils_use_enable sdl GR_VIDEO_SDL) \
		-DENABLE_GR_WXGUI=OFF \
		-DENABLE_GR_CORE=ON \
		-DSYSCONFDIR="${EPREFIX}"/etc \
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	use qt4 && mycmakeargs+=( -DQWT_INCLUDE_DIRS="${EPREFIX}"/usr/include/qwt5 )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		dodir /usr/share/doc/${PF}/
		mv "${ED}"/usr/share/${PN}/examples "${ED}"/usr/share/doc/${PF}/ || die
	else
	# It seems that the examples are always installed
		rm -rf "${ED}"/usr/share/${PN}/examples || die
	fi

	# We install the mimetypes to the correct locations from the ebuild
	rm -rf "${ED}"/usr/share/${PN}/grc/freedesktop || die
	rm -f "${ED}"/usr/libexec/${PN}/grc_setup_freedesktop || die

	# Install icons, menu items and mime-types for GRC
	if use grc ; then
		local fd_path="${S}/grc/freedesktop"
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
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
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
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		for size in ${GRC_ICON_SIZES} ; do
			xdg-icon-resource uninstall --noupdate --context mimetypes --size ${size} \
				application-gnuradio-grc || ewarn "icon uninstall failed"
			xdg-icon-resource uninstall --noupdate --context apps --size ${size} \
				gnuradio-grc || ewarn "icon uninstall failed"

		done
		xdg-icon-resource forceupdate
	fi
}
