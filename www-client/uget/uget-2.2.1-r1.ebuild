# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://www.ugetdm.com"
SRC_URI="mirror://sourceforge/urlget/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="aria2 appindicator control-socket +gnutls gstreamer libnotify nls openssl rss"
REQUIRED_USE="^^ ( gnutls openssl )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libpcre
	net-misc/curl
	>=x11-libs/gtk+-3.4:3
	gnutls? (
		net-libs/gnutls
		dev-libs/libgcrypt:0
	)
	aria2? ( net-misc/aria2[xmlrpc] )
	appindicator? ( dev-libs/libappindicator:3 )
	gstreamer? ( media-libs/gstreamer:1.0 )
	libnotify? ( x11-libs/libnotify )
	openssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	local myconf=(
		$(use_enable appindicator)
		$(use_enable control-socket unix_socket)
		$(use_enable gstreamer)
		$(use_enable libnotify notify)
		$(use_enable nls)
		$(use_enable rss rss_notify)
		$(use_with gnutls)
		$(use_with openssl)
	)

	econf "${myconf[@]}"
}
