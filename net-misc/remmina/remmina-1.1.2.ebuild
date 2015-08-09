# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit gnome2-utils cmake-utils

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/FreeRDP/Remmina/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/FreeRDP/Remmina.git
		https://github.com/FreeRDP/Remmina.git"
	KEYWORDS=""
fi

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://freerdp.github.io/Remmina/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ayatana avahi crypt debug freerdp gnome-keyring nls ssh telepathy vte"

RDEPEND="
	x11-libs/gtk+:3
	>=dev-libs/glib-2.31.18:2
	>=net-libs/libvncserver-0.9.8.2
	x11-libs/libxkbfile
	x11-themes/gnome-icon-theme
	x11-libs/gdk-pixbuf
	x11-libs/libX11
	avahi? ( net-dns/avahi[gtk3] )
	ayatana? ( dev-libs/libappindicator )
	crypt? ( dev-libs/libgcrypt:0 )
	freerdp? (
		>=net-misc/freerdp-1.1.0_beta1_p20130710
		<net-misc/freerdp-1.2
	)
	gnome-keyring? ( gnome-base/libgnome-keyring )
	ssh? ( net-libs/libssh[sftp] )
	telepathy? ( net-libs/telepathy-glib )
	vte? ( x11-libs/vte:2.90 )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND+="
	!net-misc/remmina-plugins
"

DOCS=( README )
PATCHES=( "${FILESDIR}/remmina-external_tools.patch" )

S="${WORKDIR}/Remmina-${PV}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with ayatana APPINDICATOR)
		$(cmake-utils_use_with avahi AVAHI)
		$(cmake-utils_use_with crypt GCRYPT)
		$(cmake-utils_use_with freerdp FREERDP)
		$(cmake-utils_use_with gnome-keyring GNOMEKEYRING)
		$(cmake-utils_use_with nls GETTEXT)
		$(cmake-utils_use_with nls TRANSLATIONS)
		$(cmake-utils_use_with ssh LIBSSH)
		$(cmake-utils_use_with telepathy TELEPATHY)
		$(cmake-utils_use_with vte VTE)
		-DGTK_VERSION=3
		-DHAVE_PTHREAD=ON
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
