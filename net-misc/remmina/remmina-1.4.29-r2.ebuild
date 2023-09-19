# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake optfeature python-single-r1 xdg

MY_P="${PN^}-v${PV}"

DESCRIPTION="A GTK+ RDP, SPICE, VNC and SSH client"
HOMEPAGE="https://remmina.org/"
SRC_URI="https://gitlab.com/Remmina/Remmina/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"
IUSE="+appindicator crypt cups examples keyring gvnc kwallet nls python spice ssh rdp vnc wayland webkit zeroconf"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libpcre2
	dev-libs/libsodium:=
	dev-libs/openssl:0=
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[wayland?]
	x11-libs/libX11
	x11-libs/libxkbfile
	appindicator? ( dev-libs/libayatana-appindicator )
	crypt? ( dev-libs/libgcrypt:0= )
	keyring? ( app-crypt/libsecret )
	gvnc? ( net-libs/gtk-vnc )
	kwallet? ( kde-frameworks/kwallet )
	python? ( ${PYTHON_DEPS} )
	rdp? ( >=net-misc/freerdp-2.0.0_rc4_p1129[X]
		<net-misc/freerdp-3[X]
		cups? ( net-print/cups:= ) )
	spice? ( net-misc/spice-gtk[gtk3] )
	ssh? ( net-libs/libssh:0=[sftp]
		x11-libs/vte:2.91 )
	vnc? ( net-libs/libvncserver[jpeg] )
	webkit? ( net-libs/webkit-gtk:4.1 )
	zeroconf? ( >=net-dns/avahi-0.8-r2[dbus,gtk] )
"

DEPEND="
	${COMMON_DEPEND}
	spice? ( app-emulation/spice-protocol )
"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RDEPEND="
	${COMMON_DEPEND}
	virtual/freedesktop-icon-theme
"

DOCS=( AUTHORS CHANGELOG.md README.md THANKS.md )

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

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
		-DWITH_LIBSECRET=$(usex keyring)
		-DWITH_LIBSSH=$(usex ssh)
		-DWITH_LIBVNCSERVER=$(usex vnc)
		-DWITH_PYTHONLIBS=$(usex python ON OFF)
		-DWITH_SPICE=$(usex spice)
		-DWITH_TRANSLATIONS=$(usex nls)
		-DWITH_UPDATE_DESKTOP_DB=OFF
		-DWITH_VTE=$(usex ssh)
		-DWITH_WWW=$(usex webkit)
		-DWITH_X2GO=OFF
		# when this feature is stable, add python eclass usage to optionally enable
		-DWITH_PYTHON=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "encrypted VNC connections" net-libs/libvncserver[gcrypt]
}
