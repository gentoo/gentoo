# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils gnome2-utils xdg-utils

MY_P="${PN^}-v${PV}"

DESCRIPTION="A GTK+ RDP, SPICE, VNC, XDMCP and SSH client"
HOMEPAGE="https://remmina.org/"
SRC_URI="https://gitlab.com/Remmina/Remmina/-/archive/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="appindicator crypt cups examples gnome-keyring kwallet libressl nls spice ssh rdp telepathy vnc webkit zeroconf"

CDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libsodium:=
	net-libs/libsoup
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxkbfile
	appindicator? ( dev-libs/libappindicator:3 )
	crypt? ( dev-libs/libgcrypt:0= )
	rdp? ( >=net-misc/freerdp-2.0.0_rc4_p1129
		<net-misc/freerdp-3
		cups? ( net-print/cups:= ) )
	gnome-keyring? ( app-crypt/libsecret )
	kwallet? ( kde-frameworks/kwallet )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	spice? ( net-misc/spice-gtk[gtk3] )
	ssh? ( net-libs/libssh:0=[sftp]
		x11-libs/vte:2.91 )
	telepathy? ( net-libs/telepathy-glib )
	vnc? ( net-libs/libvncserver[jpeg] )
	webkit? ( net-libs/webkit-gtk:4 )
	zeroconf? ( || ( >=net-dns/avahi-0.8-r2[dbus,gtk] <net-dns/avahi-0.8-r2[dbus,gtk3] ) )
"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="${CDEPEND}
	virtual/freedesktop-icon-theme
"

DOCS=( AUTHORS CHANGELOG.md README.md THANKS.md )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e '/^OnlyShowIn=Unity;$/d' data/desktop/org.remmina.Remmina.desktop.in || die
	default
}

src_configure() {
	local mycmakeargs=(
		-DWITH_APPINDICATOR=$(usex appindicator)
		-DWITH_GCRYPT=$(usex crypt)
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_LIBSECRET=$(usex gnome-keyring)
		-DWITH_KF5WALLET=$(usex kwallet)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_TRANSLATIONS=$(usex nls)
		-DWITH_FREERDP=$(usex rdp)
		-DWITH_CUPS=$(usex cups)
		-DWITH_SPICE=$(usex spice)
		-DWITH_LIBSSH=$(usex ssh)
		-DWITH_VTE=$(usex ssh)
		-DWITH_TELEPATHY=$(usex telepathy)
		-DWITH_LIBVNCSERVER=$(usex vnc)
		-DWITH_WWW=$(usex webkit)
		-DWITH_AVAHI=$(usex zeroconf)
		-DWITH_ICON_CACHE=OFF
		-DWITH_UPDATE_DESKTOP_DB=OFF
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	elog "To get additional features, some optional runtime dependencies"
	elog "may be installed:"
	elog ""
	optfeature "encrypted VNC connections" net-libs/libvncserver[gcrypt]
	optfeature "XDMCP support" x11-base/xorg-server[xephyr]
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
