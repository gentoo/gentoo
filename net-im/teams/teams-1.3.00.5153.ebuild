# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

DESCRIPTION="Microsoft Teams, an Office 365 multimedia collaboration client, pre-release"
HOMEPAGE="https://products.office.com/en-us/microsoft-teams/group-chat-software/"
SRC_URI="https://packages.microsoft.com/repos/ms-teams/pool/main/t/${PN}/${PN}_${PV}_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror splitdebug test"
IUSE=""

QA_PREBUILT="*"

# libasound2 (>= 1.0.16), libatk-bridge2.0-0 (>= 2.5.3), libatk1.0-0 (>= 1.12.4), libc6 (>= 2.17), libcairo2 (>= 1.6.0), libcups2 (>= 1.4.0),
# libexpat1 (>= 2.0.1), libgcc1 (>= 1:3.0), libgdk-pixbuf2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.35.8), libgtk-3-0 (>= 3.9.10), libnspr4 (>= 2:4.9-2~), libnss3
# (>= 2:3.22), libpango-1.0-0 (>= 1.14.0), libpangocairo-1.0-0 (>= 1.14.0), libsecret-1-0 (>= 0.7), libuuid1 (>= 2.16), libx11-6 (>= 2:1.4.99.1), libx11-xcb1,
# libxcb1 (>= 1.6), libxcomposite1 (>= 1:0.3-1), libxcursor1 (>> 1.1.2), libxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxi6 (>= 2:1.2.99.4), libxkbfile1,
# libxrandr2 (>= 2:1.2.99.3), libxrender1, libxss1, libxtst6, apt-transport-https, libfontconfig1 (>= 2.11.0), libdbus-1-3 (>= 1.6.18), libstdc++6 (>= 4.8.1)
RDEPEND="
	app-accessibility/at-spi2-atk
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	gnome-base/libgnome-keyring
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa
	media-video/ffmpeg[chromium]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
"

S="${WORKDIR}"

src_install() {
	rm _gpgorigin || die
	doins -r .

	fperms +x /usr/bin/teams
	fperms +x /usr/share/teams/teams

	# use system ffmpeg
	rm -f "${D}"/usr/share/teams/libffmpeg.so || die

	cat > 99teams <<-EOF
		LDPATH=${EROOT%/}/usr/$(get_libdir)/chromium
	EOF
	doenvd 99teams

	# use system mesa
	rm -f "${D}"/usr/share/teams/libEGL.so || die
	rm -f "${D}"/usr/share/teams/libGLESv2.so || die
	rm -f "${D}"/usr/share/teams/swiftshader/libEGL.so || die
	rm -f "${D}"/usr/share/teams/swiftshader/libGLESv2.so || die

	sed -i '/OnlyShowIn=/d' "${S}"/usr/share/applications/teams.desktop || die
	domenu usr/share/applications/teams.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
