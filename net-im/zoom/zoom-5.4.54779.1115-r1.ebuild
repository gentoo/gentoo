# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eapi8-dosym readme.gentoo-r1 xdg-utils

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://zoom.us/"
SRC_URI="https://zoom.us/client/${PV}/${PN}_x86_64.tar.xz -> ${P}_x86_64.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved Apache-2.0" # Apache-2.0 for icon
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="bundled-libjpeg-turbo +bundled-qt pulseaudio wayland"
RESTRICT="mirror bindist strip"

RDEPEND="!games-engines/zoom
	dev-libs/glib:2
	dev-libs/quazip
	media-sound/mpg123
	sys-apps/dbus
	sys-apps/util-linux
	virtual/opengl
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	pulseaudio? ( media-sound/pulseaudio )
	!pulseaudio? ( media-libs/alsa-lib )
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
		dev-qt/qtscript:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		wayland? ( dev-qt/qtwayland )
	)"

BDEPEND="!pulseaudio? ( dev-util/bbe )"

QA_PREBUILT="opt/zoom/*"

src_prepare() {
	default
	if ! use pulseaudio; then
		# For some strange reason, zoom cannot use any ALSA sound devices if
		# it finds libpulse. This causes breakage if media-sound/apulse[sdk]
		# is installed. So, force zoom to ignore libpulse.
		bbe -e 's/libpulse.so/IgNoRePuLsE/' zoom >zoom.tmp || die
		mv zoom.tmp zoom || die
	fi
}

src_install() {
	insinto /opt/zoom
	exeinto /opt/zoom
	doins -r json ringtone sip timezones translations
	doins *.pcm *.sh Embedded.properties version.txt
	doexe zoom zoom.sh zopen ZoomLauncher
	dosym8 -r {"/usr/$(get_libdir)",/opt/zoom}/libmpg123.so
	dosym8 -r {"/usr/$(get_libdir)",/opt/zoom}/libquazip.so

	if use bundled-libjpeg-turbo; then
		doexe libturbojpeg.so
	else
		dosym8 -r {"/usr/$(get_libdir)",/opt/zoom}/libturbojpeg.so
	fi

	if use bundled-qt; then
		doexe libicu*.so.56 libQt5*.so.5
		doins qt.conf

		local dirs="Qt* audio generic iconengines imageformats platform* \
			wayland* xcbglintegrations"
		doins -r ${dirs}
		find ${dirs} -type f '(' -name '*.so' -o -name '*.so.*' ')' \
			-printf '/opt/zoom/%p\0' | xargs -0 -r fperms 0755 || die

		(	# Remove libs and plugins with unresolved soname dependencies
			cd "${ED}"/opt/zoom || die
			rm -r Qt/labs/location QtQml/RemoteObjects QtQuick/Scene{2D,3D} \
				platforms/libqeglfs.so || die
			use wayland || rm -r libQt5Wayland*.so* QtWayland wayland* \
				platforms/libqwayland*.so || die
		)
	fi

	dosym8 -r /opt/zoom/ZoomLauncher /usr/bin/zoom
	make_desktop_entry "zoom %U" Zoom zoom-videocam "" \
		"MimeType=x-scheme-handler/zoommtg;application/x-zoom;"
	# The tarball doesn't contain an icon, so take a generic camera icon
	# from https://github.com/google/material-design-icons, modified to be
	# white on a blue background
	doicon -s scalable "${FILESDIR}"/zoom-videocam.svg
	doicon -s 24 "${FILESDIR}"/zoom-videocam.xpm
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	local FORCE_PRINT_ELOG v
	for v in ${REPLACING_VERSIONS}; do
		ver_test ${v} -le 5.0.403652.0509 && FORCE_PRINT_ELOG=1
	done
	readme.gentoo_print_elog

	if use bundled-libjpeg-turbo; then
		ewarn "If the \"bundled-libjpeg-turbo\" flag is enabled, you may see a"
		ewarn "QA notice about insecure RPATHs in the libturbojpeg.so library"
		ewarn "bundled with the upstream package. Please report this problem"
		ewarn "directly to Zoom upstream. Do *not* file a Gentoo bug for it."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
