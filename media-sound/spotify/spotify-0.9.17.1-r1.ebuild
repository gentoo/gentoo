# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils fdo-mime gnome2-utils pax-utils unpacker

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/download/previews/"
MY_PV="${PV}.g9b85d43.7-1"
MY_P="${PN}-client_${MY_PV}"
SRC_BASE="http://repository.spotify.com/pool/non-free/${PN:0:1}/${PN}/"
SRC_URI="
	amd64? ( ${SRC_BASE}${MY_P}_amd64.deb )
	"
#	x86?   ( ${SRC_BASE}${MY_P}_i386.deb )
LICENSE="Spotify"
SLOT="0"
#amd64 and x86 keywords removed due to security concerns, see bug 474010
KEYWORDS="~amd64"
IUSE="gnome pax_kernel pulseaudio"
RESTRICT="mirror strip"

DEPEND=""
RDEPEND="${DEPEND}
		x11-libs/libxcb
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXdmcp
		x11-libs/libXScrnSaver
		x11-libs/libXrandr
		x11-libs/libXrender
		dev-qt/qtcore:4[glib]
		dev-qt/qtdbus:4
		dev-qt/qtgui:4[glib]
		dev-qt/qtwebkit:4
		x11-misc/xdg-utils
		media-libs/alsa-lib
		media-libs/fontconfig
		media-libs/freetype
		dev-libs/openssl:0
		dev-libs/glib:2
		|| ( dev-libs/libgcrypt:11/11 dev-libs/libgcrypt:0/11 )
		media-libs/libpng:0
		dev-db/sqlite:3
		sys-libs/zlib
		app-arch/bzip2
		sys-apps/dbus[X]
		x11-libs/pango[X]
		sys-apps/util-linux
		dev-libs/expat
		>=dev-libs/nspr-4.9
		gnome-base/gconf:2
		x11-libs/gtk+:2
		dev-libs/nss
		dev-libs/glib:2
		net-print/cups
		virtual/udev
		pulseaudio? ( >=media-sound/pulseaudio-0.9.21 )
		gnome? ( gnome-extra/gnome-integration-spotify )"

S=${WORKDIR}

QA_PREBUILT="/opt/spotify/spotify-client/spotify
			/opt/spotify/spotify-client/Data/SpotifyHelper
			/opt/spotify/spotify-client/Data/libcef.so"

src_prepare() {
	# Fix desktop entry to launch spotify-dbus.py for GNOME integration
	if use gnome ; then
	sed -i \
		-e 's/spotify \%U/spotify-dbus.py \%U/g' \
		opt/spotify/spotify-client/spotify.desktop || die "sed failed"
	fi
	#and fix other stuff in the desktop file as well
	sed -i \
		-e 's/x-scheme-handler\/spotify$/x-scheme-handler\/spotify\;/g' \
		-e 's/AudioVideo$/AudioVideo\;/g' \
		opt/spotify/spotify-client/spotify.desktop || die "sed failed"
}

src_install() {
	dodoc opt/spotify/spotify-client/changelog
	dodoc usr/share/doc/spotify-client/changelog.Debian.gz
	dodoc usr/share/doc/spotify-client/copyright

	insinto /usr/share/pixmaps
	doins opt/spotify/spotify-client/Icons/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify/spotify-client
	insinto ${SPOTIFY_HOME}
	doins -r opt/spotify/spotify-client/*
	fperms +x ${SPOTIFY_HOME}/spotify
	fperms +x ${SPOTIFY_HOME}/Data/SpotifyHelper

	dodir /usr/bin
	cat <<-EOF >"${D}"/usr/bin/spotify
		#! /bin/sh
		exec ${SPOTIFY_HOME}/spotify "\$@"
	EOF
	fperms +x /usr/bin/spotify

	# revdep-rebuild produces a false positive because of symbol versioning
	dodir /etc/revdep-rebuild
	cat <<-EOF >"${D}"/etc/revdep-rebuild/10${PN}
		SEARCH_DIRS_MASK="${SPOTIFY_HOME}"
	EOF

	for size in 16 22 24 32 48 64 128 256; do
		newicon -s ${size} "${S}${SPOTIFY_HOME}/Icons/spotify-linux-${size}.png" \
			"spotify-client.png"
	done
	domenu "${S}${SPOTIFY_HOME}/spotify.desktop"

	if use pax_kernel; then
		#create the headers, reset them to default, then paxmark -m them
		pax-mark C "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark C "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi

	#TODO fix for x86
	dosym /usr/lib/libudev.so "${SPOTIFY_HOME}/Data/libudev.so.0"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
	ewarn
	ewarn "you need to use the ld.bfd linker with openssl"
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
