# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake optfeature xdg

MY_P="${PN^}-v${PV}"

DESCRIPTION="A GTK+ RDP, SPICE, VNC and SSH client"
HOMEPAGE="https://remmina.org/"
SRC_URI="https://gitlab.com/Remmina/Remmina/-/archive/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+appindicator crypt cups examples gnome-keyring gvnc kwallet nls spice ssh rdp telemetry vnc webkit x2go zeroconf"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libpcre2
	dev-libs/libsodium:=
	dev-libs/openssl:0=
	net-libs/libsoup:2.4
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxkbfile
	appindicator? ( dev-libs/libappindicator:3 )
	crypt? ( dev-libs/libgcrypt:0= )
	gnome-keyring? ( app-crypt/libsecret )
	gvnc? ( net-libs/gtk-vnc )
	kwallet? ( kde-frameworks/kwallet )
	rdp? ( >=net-misc/freerdp-2.0.0_rc4_p1129[X]
		<net-misc/freerdp-3[X]
		cups? ( net-print/cups:= ) )
	spice? ( net-misc/spice-gtk[gtk3] )
	ssh? ( net-libs/libssh:0=[sftp]
		x11-libs/vte:2.91 )
	vnc? ( net-libs/libvncserver[jpeg] )
	webkit? ( net-libs/webkit-gtk:4 )
	x2go? ( net-misc/pyhoca-cli )
	zeroconf? ( >=net-dns/avahi-0.8-r2[dbus,gtk] )
"

DEPEND="
	${COMMON_DEPEND}
	spice? ( app-emulation/spice-protocol )
"

BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RDEPEND="
	${COMMON_DEPEND}
	virtual/freedesktop-icon-theme
"

DOCS=( AUTHORS CHANGELOG.md README.md THANKS.md )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	xdg_environment_reset
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_LIBAPPINDICATOR=$(usex appindicator ON OFF)
		-DWITH_AVAHI=$(usex zeroconf)
		-DWITH_CUPS=$(usex cups)
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_FREERDP=$(usex rdp)
		-DWITH_FREERDP3=OFF
		-DWITH_GCRYPT=$(usex crypt)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_ICON_CACHE=OFF
		-DWITH_KF5WALLET=$(usex kwallet)
		-DWITH_LIBSECRET=$(usex gnome-keyring)
		-DWITH_LIBSSH=$(usex ssh)
		-DWITH_LIBVNCSERVER=$(usex vnc)
		-DWITH_NEWS=$(usex telemetry)
		-DWITH_SPICE=$(usex spice)
		-DWITH_TRANSLATIONS=$(usex nls)
		-DWITH_UPDATE_DESKTOP_DB=OFF
		-DWITH_VTE=$(usex ssh)
		-DWITH_WWW=$(usex webkit)
		-DWITH_X2GO=$(usex x2go)
		# when this feature is stable, add python eclass usage to optionally enable
		-DWITH_PYTHON=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "encrypted VNC connections" net-libs/libvncserver[gcrypt]
}
