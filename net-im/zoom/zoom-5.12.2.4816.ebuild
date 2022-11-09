# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop linux-info readme.gentoo-r1 wrapper xdg-utils

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://zoom.us/"
SRC_URI="https://zoom.us/client/${PV}/${PN}_x86_64.tar.xz -> ${P}_x86_64.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="bundled-libjpeg-turbo +bundled-qt opencl pulseaudio wayland"
RESTRICT="mirror bindist strip"

RDEPEND="!games-engines/zoom
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/quazip-1.0:0=[qt5(+)]
	media-libs/alsa-lib
	media-libs/fdk-aac:0/2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa[gbm(+)]
	media-sound/mpg123
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	virtual/opengl
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon[X]
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxshmfence
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	opencl? ( virtual/opencl )
	pulseaudio? ( media-libs/libpulse )
	wayland? ( dev-libs/wayland )
	!bundled-libjpeg-turbo? ( >=media-libs/libjpeg-turbo-2.0.5 )
	!bundled-qt? (
		dev-libs/icu
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtdeclarative:5[widgets]
		dev-qt/qtdiag:5
		dev-qt/qtgraphicaleffects:5
		dev-qt/qtgui:5
		dev-qt/qtlocation:5
		dev-qt/qtnetwork:5
		dev-qt/qtquickcontrols:5[widgets]
		dev-qt/qtquickcontrols2:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		wayland? ( dev-qt/qtwayland )
	)"

BDEPEND="dev-util/bbe
	bundled-libjpeg-turbo? ( dev-util/patchelf )"

CONFIG_CHECK="~USER_NS ~PID_NS ~NET_NS ~SECCOMP_FILTER"
QA_PREBUILT="opt/zoom/*"

src_prepare() {
	default

	# The tarball doesn't contain an icon, so extract it from the binary
	bbe -s -b '/<svg width="32" height="32"/:/<\x2fsvg>\n/' -e 'J 1;D' zoom \
		>videoconference-zoom.svg && [[ -s videoconference-zoom.svg ]] \
		|| die "Extraction of icon failed"

	if ! use pulseaudio; then
		# For some strange reason, zoom cannot use any ALSA sound devices if
		# it finds libpulse. This causes breakage if media-sound/apulse[sdk]
		# is installed. So, force zoom to ignore libpulse.
		bbe -e 's/libpulse.so/IgNoRePuLsE/' zoom >zoom.tmp || die
		mv zoom.tmp zoom || die
	fi

	if use bundled-libjpeg-turbo; then
		# Remove insecure RPATH from bundled lib
		patchelf --remove-rpath libturbojpeg.so || die
	fi
}

src_install() {
	insinto /opt/zoom
	exeinto /opt/zoom
	doins -r cef json ringtone scheduler sip timezones translations
	doins *.pcm Embedded.properties version.txt
	doexe zoom zopen ZoomLauncher *.sh
	dosym -r {"/usr/$(get_libdir)",/opt/zoom}/libmpg123.so
	dosym -r "/usr/$(get_libdir)/libfdk-aac.so.2" /opt/zoom/libfdkaac2.so
	dosym -r "/usr/$(get_libdir)/libquazip1-qt5.so" /opt/zoom/libquazip.so

	if use opencl; then
		doexe aomhost libaomagent.so libclDNN64.so libmkldnn.so
		dosym -r {"/usr/$(get_libdir)",/opt/zoom}/libOpenCL.so.1
	fi

	if use bundled-libjpeg-turbo; then
		doexe libturbojpeg.so
	else
		dosym -r {"/usr/$(get_libdir)",/opt/zoom}/libturbojpeg.so
	fi

	if use bundled-qt; then
		doexe libicu*.so.56 libQt5*.so.5
		doins qt.conf

		local dirs="Qt* bearer generic iconengines imageformats \
			platforminputcontexts platforms wayland* xcbglintegrations"
		doins -r ${dirs}
		find ${dirs} -type f '(' -name '*.so' -o -name '*.so.*' ')' \
			-printf '/opt/zoom/%p\0' | xargs -0 -r fperms 0755 || die

		(	# Remove libs and plugins with unresolved soname dependencies
			cd "${ED}"/opt/zoom || die
			rm -r Qt/labs/location QtQuick/LocalStorage QtQuick/Particles.2 \
				QtQuick/Scene2D QtQuick/Scene3D QtQuick/XmlListModel \
				platforms/libqeglfs.so platforms/libqlinuxfb.so || die
			use wayland || rm -r libQt5Wayland*.so* QtWayland wayland* \
				platforms/libqwayland*.so || die
		)
	else
		local qtzoom="5.12" qtver=$(best_version dev-qt/qtcore:5)
		if [[ ${qtver} != dev-qt/qtcore-${qtzoom}.* ]]; then
			ewarn "You have disabled the bundled-qt USE flag."
			ewarn "You may experience problems when running Zoom with"
			ewarn "a version of the system-wide Qt libs other than ${qtzoom}."
			ewarn "See https://bugs.gentoo.org/798681 for details."
		fi
	fi

	make_wrapper zoom /opt/zoom{/zoom,} /opt/zoom:/opt/zoom/cef
	make_desktop_entry "zoom %U" Zoom videoconference-zoom \
		"Network;VideoConference;" \
		"MimeType=$(printf '%s;' \
			x-scheme-handler/zoommtg \
			x-scheme-handler/zoomus \
			application/x-zoom)"
	doicon videoconference-zoom.svg
	doicon -s scalable videoconference-zoom.svg

	local DOC_CONTENTS="Some of Zoom's screen share features (e.g.
		the whiteboard) require display compositing. If you encounter
		a black window when sharing the screen, then one of the following
		actions should help:
		\\n- Enable compositing in your window manager if it is supported
		\\n- Alternatively, run the xcompmgr command (from x11-misc/xcompmgr)"
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
