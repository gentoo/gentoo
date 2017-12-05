# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils gnome2-utils

MY_PV="${PV//_rc/-rcgit.}"

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://remmina.org/"
SRC_URI="https://github.com/FreeRDP/Remmina/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana crypt rdp gnome-keyring nls spice ssh telepathy zeroconf"

RDEPEND="
	dev-libs/glib:2
	net-libs/libvncserver
	x11-libs/libxkbfile
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	virtual/freedesktop-icon-theme
	ayatana? ( dev-libs/libappindicator:3 )
	crypt? ( dev-libs/libgcrypt:0= )
	rdp? ( >=net-misc/freerdp-2.0.0_pre20161219 )
	gnome-keyring? ( app-crypt/libsecret )
	spice? ( net-misc/spice-gtk[gtk3] )
	ssh? ( net-libs/libssh[sftp]
		x11-libs/vte:2.91 )
	telepathy? ( net-libs/telepathy-glib )
	zeroconf? ( net-dns/avahi[gtk3] )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( README.md )

S="${WORKDIR}/Remmina-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DWITH_APPINDICATOR=$(usex ayatana)
		-DWITH_GCRYPT=$(usex crypt)
		-DWITH_FREERDP=$(usex rdp freerdp)
		-DWITH_LIBSECRET=$(usex gnome-keyring)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_TRANSLATIONS=$(usex nls)
		-DWITH_SPICE=$(usex spice)
		-DWITH_LIBSSH=$(usex ssh)
		-DWITH_VTE=$(usex ssh)
		-DWITH_TELEPATHY=$(usex telepathy)
		-DWITH_AVAHI=$(usex zeroconf)
		-DGTK_VERSION=3
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "To get additional features, some optional runtime dependencies"
	elog "may be installed:"
	elog ""
	optfeature "encrypted VNC connections" net-libs/libvncserver[gcrypt]
	optfeature "XDMCP support" x11-base/xorg-server[xephyr]
}

pkg_postrm() {
	gnome2_icon_cache_update
}
