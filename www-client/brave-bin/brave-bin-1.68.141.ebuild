# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BRAVE_PN="${PN/-bin/}"

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 xdg-utils desktop

DESCRIPTION="Brave Web Browser"
HOMEPAGE="https://brave.com"
SRC_URI="https://github.com/brave/brave-browser/releases/download/v${PV}/brave-browser-${PV}-linux-amd64.zip -> ${P}.zip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="keyring"

# gconf is deprecated.
# DEPEND="gnome-base/gconf:2"
RDEPEND="
	${DEPEND}
	dev-libs/libpthread-stubs
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	x11-libs/libXScrnSaver
	x11-libs/libXrandr
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXinerama
	x11-libs/libxkbcommon
	dev-libs/glib
	dev-libs/nss
	dev-libs/nspr
	net-print/cups
	sys-apps/dbus
	dev-libs/expat
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	dev-libs/gobject-introspection
	dev-libs/atk
	app-accessibility/at-spi2-core
	app-accessibility/at-spi2-atk
	x11-libs/gtk+
	x11-libs/gdk-pixbuf
	dev-libs/libffi
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/zlib
	dev-libs/fribidi
	media-libs/harfbuzz
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	>=media-libs/libpng-1.6.34
	media-libs/libepoxy
	dev-libs/libbsd
	dev-libs/libunistring
	dev-libs/libtasn1
	dev-libs/nettle
	dev-libs/gmp
	net-dns/libidn2
	media-gfx/graphite2
	app-arch/bzip2
"

QA_PREBUILT="*"

S=${WORKDIR}

src_prepare() {
	pushd "${S}/locales" > /dev/null || die
		chromium_remove_language_paks
	popd > /dev/null || die

	default
}

src_install() (
	shopt -s extglob

		declare BRAVE_HOME=/opt/${BRAVE_PN}

		dodir ${BRAVE_HOME%/*}

		insinto ${BRAVE_HOME}
			doins -r *
    # Brave has a bug in 1.27.105 where it needs crashpad_handler chmodded
    # Delete crashpad_handler when https://github.com/brave/brave-browser/issues/16985 is resolved.
			exeinto ${BRAVE_HOME}
				doexe brave chrome_crashpad_handler

		dosym ${BRAVE_HOME}/brave /usr/bin/${PN} || die

	# Install Icons for Brave. 
		newicon "${FILESDIR}/braveAbout.png" "${PN}.png" || die
		newicon -s 128 "${FILESDIR}/braveAbout.png" "${PN}.png" || die

	# install-xattr doesnt approve using domenu or doins from FILESDIR
		cp "${FILESDIR}"/${PN}.desktop "${S}"
		domenu "${S}"/${PN}.desktop
)

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
    xdg_icon_cache_update
	elog "If upgrading from 1.50.x release or earlier, note that Brave has changed the format of the"
	elog "password file, and ALL YOUR OLD PASSWORDS WILL NOT WORK."
	elog "YOUR BRAVE REWARDS WILL NOT WORK EITHER."
	elog "The solution is to temporarily downgrade back to 1.50.x (legacy ebuild provided),"
	elog "so you can export passwords from Brave's Password Manager."
	elog "once you're back in a newer build, import passwords from inside Brave's Password Manager,"
	elog "and select the file you saved."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
    xdg_icon_cache_update
}
