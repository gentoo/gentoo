# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop pax-utils unpacker xdg

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"
SRC_BASE="http://repository.spotify.com/pool/non-free/s/${PN}-client/"
BUILD_ID_AMD64="498.gf9a83c60"
SRC_URI="${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_AMD64}_amd64.deb"
LICENSE="Spotify"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify libressl systray pax_kernel pulseaudio"
RESTRICT="mirror strip"

BDEPEND=">=dev-util/patchelf-0.10"
RDEPEND="
	dev-libs/nss
	dev-python/dbus-python
	dev-python/pygobject:3
	libnotify? ( x11-libs/libnotify )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/harfbuzz
	media-libs/mesa[X(+)]
	net-misc/curl[ssl]
	net-print/cups[ssl]
	pulseaudio? ( media-sound/pulseaudio )
	!pulseaudio? ( media-sound/apulse )
	systray? ( gnome-extra/gnome-integration-spotify )
	x11-libs/gtk+:2
	app-accessibility/at-spi2-atk
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libSM
	x11-libs/libICE
"
	#sys-libs/glibc

S=${WORKDIR}/

QA_PREBUILT="
	opt/spotify/spotify-client/spotify
	opt/spotify/spotify-client/libEGL.so
	opt/spotify/spotify-client/libGLESv2.so
	opt/spotify/spotify-client/libcef.so
	opt/spotify/spotify-client/swiftshader/libEGL.so
	opt/spotify/spotify-client/swiftshader/libGLESv2.so
"

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
	gunzip usr/share/doc/spotify-client/changelog.gz || die
	dodoc usr/share/doc/spotify-client/changelog

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
		LD_LIBRARY_PATH="/usr/$(get_libdir)/apulse" \\
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
		eqawarn "${PN} under a PaX enabled kernel.	To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
}
