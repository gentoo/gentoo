# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2-utils xdg-utils git-r3 autotools

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://www.ugetdm.com"
SRC_URI=""
EGIT_REPO_URI="git://git.code.sf.net/p/urlget/uget2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="aria2 appindicator control-socket +gnutls gstreamer libnotify nls openssl rss"

RDEPEND="
	>=net-misc/curl-7.19.1
	dev-libs/libpcre
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.4:3
	gnutls? (
		net-libs/gnutls
		dev-libs/libgcrypt:0
	)
	aria2? ( net-misc/aria2[xmlrpc] )
	appindicator? ( dev-libs/libappindicator:3 )
	gstreamer? ( media-libs/gstreamer:1.0 )
	libnotify? ( x11-libs/libnotify )
	"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	"

src_prepare() {
	eapply_user
	eautoreconf
}

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
		--disable-pwmd
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
