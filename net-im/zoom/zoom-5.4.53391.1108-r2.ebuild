# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eapi8-dosym readme.gentoo-r1 wrapper xdg-utils

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://zoom.us/"
SRC_URI="amd64? ( https://zoom.us/client/${PV}/${PN}_x86_64.tar.xz -> ${P}_x86_64.tar.xz )
	x86? ( https://zoom.us/client/${PV}/${PN}_i686.tar.xz -> ${P}_i686.tar.xz )"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libjpeg-turbo pulseaudio"
RESTRICT="mirror bindist strip"

RDEPEND="!games-engines/zoom
	dev-libs/glib:2
	dev-libs/icu
	dev-libs/quazip:0=
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
	!bundled-libjpeg-turbo? ( media-libs/libjpeg-turbo )
	pulseaudio? ( media-sound/pulseaudio )
	!pulseaudio? ( media-libs/alsa-lib )"

BDEPEND="dev-util/bbe
	bundled-libjpeg-turbo? ( dev-util/patchelf )"

QA_PREBUILT="opt/zoom/*"

src_prepare() {
	default

	# The tarball doesn't contain an icon, so extract it from the binary
	bbe -s -b '/<svg width="32"/:/<\x2fsvg>\n/' -e 'J 1;D' zoom \
		>zoom-videocam.svg && [[ -s zoom-videocam.svg ]] \
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
	doins -r json ringtone sip timezones translations
	doins *.pcm *.pem *.sh Embedded.properties version.txt
	doexe zoom zoom.sh zopen ZoomLauncher
	dosym8 -r {"/usr/$(get_libdir)",/opt/zoom}/libmpg123.so

	local quazip_so="libquazip1-qt5.so"
	if has_version "<dev-libs/quazip-1.0"; then
		quazip_so="libquazip5.so"
	fi
	dosym8 -r "/usr/$(get_libdir)/${quazip_so}" /opt/zoom/libquazip.so

	if use bundled-libjpeg-turbo; then
		doexe libturbojpeg.so
	else
		dosym8 -r {"/usr/$(get_libdir)",/opt/zoom}/libturbojpeg.so
	fi

	make_wrapper zoom /opt/zoom{/zoom,}
	make_desktop_entry "zoom %U" Zoom zoom-videocam "" \
		"MimeType=x-scheme-handler/zoommtg;application/x-zoom;"
	doicon zoom-videocam.svg
	doicon -s scalable zoom-videocam.svg
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
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
