# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

MY_P="ONLYOFFICE-DesktopEditors-"${PV}""

DESCRIPTION="Onlyoffice is an office productivity suite (binary version)"
HOMEPAGE="https://www.onlyoffice.com/"
SRC_URI="
	amd64? (
		https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v"${PV}"/onlyoffice-desktopeditors_amd64.deb
		-> "${P}"_amd64.deb
	)
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	dev-qt/qtgui:5[eglfs]
	dev-qt/qtdeclarative:5
	dev-qt/qtwayland:5
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/harfbuzz
	media-libs/libglvnd
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
	|| (
		media-libs/libpulse
		media-sound/apulse
	)
"

S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	default

	# Allow launching the ONLYOFFICE on ALSA systems via
	# media-sound/apulse
	sed -i -e 's|\(export LD_LIBRARY_PATH=$DIR$LDLPATH\)|\1:'"${EPREFIX}"'/usr/'$(get_libdir)'/apulse|' \
		"${S}"/usr/bin/onlyoffice-desktopeditors || die
}

src_install() {
	domenu usr/share/applications/onlyoffice-desktopeditors.desktop
	for size in {16,24,32,48,64,128,256}; do
		newicon -s "${size}" opt/onlyoffice/desktopeditors/asc-de-"${size}".png onlyoffice-desktopeditors.png
	done

	dobin usr/bin/desktopeditors usr/bin/onlyoffice-desktopeditors
	doins -r opt
	fperms +x /opt/onlyoffice/desktopeditors/{DesktopEditors,editors_helper,converter/x2t}
}
