# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"
SRC_BASE="http://repository.spotify.com/pool/non-free/s/${PN}-client/"
BUILD_ID_AMD64="313.g34a58dea-5"
#BUILD_ID_X86=""
#SRC_URI="amd64? ( ${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_AMD64}_amd64.deb )
#	x86? ( ${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_X86}_i386.deb )"
SRC_URI="${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_AMD64}_amd64.deb"
LICENSE="Spotify"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify systray pax_kernel pulseaudio"
RESTRICT="mirror strip"

DEPEND=">=dev-util/patchelf-0.9_p20180129"
# zenity needed for filepicker
RDEPEND="
	dev-libs/openssl:0
	dev-libs/nss
	gnome-base/gconf
	gnome-extra/zenity
	media-libs/alsa-lib
	media-libs/harfbuzz
	media-libs/fontconfig
	media-libs/mesa
	net-misc/curl[ssl]
	net-print/cups[ssl]
	x11-libs/gtk+:2
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	dev-python/pygobject:3
	dev-python/dbus-python
	libnotify? ( x11-libs/libnotify )
	pulseaudio? ( media-sound/pulseaudio )
	systray? ( gnome-extra/gnome-integration-spotify )"
	#sys-libs/glibc

S=${WORKDIR}/

QA_PREBUILT="opt/spotify/spotify-client/spotify"

src_prepare() {
	# Fix desktop entry to launch spotify-dbus.py for systray integration
	if use systray ; then
		sed -i \
			-e 's/spotify \%U/spotify-dbus.py \%U/g' \
			usr/share/spotify/spotify.desktop || die "sed failed"
	fi
	default

	# Spotify links against libcurl-gnutls.so.4, which does not exist in Gentoo.
	patchelf --replace-needed libcurl-gnutls.so.4 libcurl.so.4 usr/bin/spotify \
		|| die "failed to patch libcurl library dependency"
}

src_install() {
	dodoc usr/share/doc/spotify-client/changelog.gz

	SPOTIFY_PKG_HOME=usr/share/spotify
	insinto /usr/share/pixmaps
	doins ${SPOTIFY_PKG_HOME}/icons/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify/spotify-client
	insinto ${SPOTIFY_HOME}
	doins -r ${SPOTIFY_PKG_HOME}/*
	fperms +x ${SPOTIFY_HOME}/spotify

	dodir /usr/bin
	cat <<-EOF >"${D}"/usr/bin/spotify || die
		#! /bin/sh
		exec ${SPOTIFY_HOME}/spotify "\$@"
	EOF
	fperms +x /usr/bin/spotify

	local size
	for size in 16 22 24 32 48 64 128 256 512; do
		newicon -s ${size} "${S}${SPOTIFY_PKG_HOME}/icons/spotify-linux-${size}.png" \
			"spotify-client.png"
	done
	domenu "${S}${SPOTIFY_PKG_HOME}/spotify.desktop"
	if use pax_kernel; then
		#create the headers, reset them to default, then paxmark -m them
		pax-mark C "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/${PN}" || die
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
