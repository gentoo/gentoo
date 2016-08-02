# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils gnome2-utils versionator

MY_PV_MAIN=$(get_version_component_range 1-3)
MY_PV_RC=$(get_version_component_range 4)
MY_PV="${MY_PV_MAIN}-${MY_PV_RC//rc/rcgit.}"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/FreeRDP/Remmina/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/FreeRDP/Remmina.git
		https://github.com/FreeRDP/Remmina.git"
fi

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://remmina.org/ https://github.com/FreeRDP/Remmina"

LICENSE="GPL-2"
SLOT="0"
IUSE="ayatana crypt debug freerdp libsecret nls ssh telepathy vte webkit zeroconf"
REQUIRED_USE="ssh? ( vte )" #546886

RDEPEND="
	>=dev-libs/glib-2.31.18:2
	>=net-libs/libvncserver-0.9.8.2
	x11-libs/libxkbfile
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	virtual/freedesktop-icon-theme
	ayatana? ( dev-libs/libappindicator:3 )
	crypt? ( dev-libs/libgcrypt:0= )
	freerdp? ( >=net-misc/freerdp-2 )
	libsecret? ( app-crypt/libsecret )
	ssh? ( net-libs/libssh[sftp] )
	telepathy? ( net-libs/telepathy-glib )
	vte? ( x11-libs/vte:2.91 )
	webkit? ( || ( net-libs/webkit-gtk:4 net-libs/webkit-gtk:3 ) )
	zeroconf? ( net-dns/avahi[gtk3] )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND+="
	x11-base/xorg-server[kdrive]
	!net-misc/remmina-plugins
"

DOCS=( README.md )

S="${WORKDIR}/Remmina-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DWITH_APPINDICATOR=$(usex ayatana)
		-DWITH_GCRYPT=$(usex crypt)
		-DWITH_FREERDP=$(usex freerdp)
		-DWITH_LIBSECRET=$(usex libsecret)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_TRANSLATIONS=$(usex nls)
		-DWITH_LIBSSH=$(usex ssh)
		-DWITH_TELEPATHY=$(usex telepathy)
		-DWITH_VTE=$(usex vte)
		-DWITH_SURVEY=$(usex webkit)
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
}

pkg_postrm() {
	gnome2_icon_cache_update
}
