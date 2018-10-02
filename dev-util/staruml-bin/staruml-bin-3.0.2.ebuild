# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit appimage desktop

DESCRIPTION="A sophisticated software modeler"
HOMEPAGE="http://staruml.io/"
SRC_URI="
	amd64? ( http://staruml.io/download/releases/StarUML-${PV}-x86_64.AppImage )
	x86? ( http://staruml.io/download/releases/StarUML-${PV}-i386.AppImage )
"

LICENSE="StarUML-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror splitdebug"

RDEPEND="
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/glib:2
	dev-libs/libgcrypt:11
	dev-libs/nettle
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng
	net-libs/gnutls
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libxshmfence
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/pixman
"

S="${WORKDIR}"
QA_PREBUILT="opt/${P}/staruml opt/${P}/libffmpeg.so opt/${P}/libnode.so"

MY_PN=${PN/-bin/}

src_prepare() {
	rm -r ${P}/usr/lib
	sed -i 's/^Exec=AppRun/Exec=staruml/' "${P}/${MY_PN}.desktop" \
		|| die "Failed to patch desktop file"

	default_src_prepare
}

src_install() {
	dodir /opt
	mv ${P} "${ED}"/opt || die "Failed to move directory"

	dosym ../../opt/${P}/${MY_PN} /usr/bin/${MY_PN}
	domenu "${ED}"/opt/${P}/${MY_PN}.desktop
	doicon "${ED}"/opt/${P}/${MY_PN}.png
}
