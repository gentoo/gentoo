# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit xdg

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://www.ugetdm.com"
SRC_URI="mirror://sourceforge/urlget/${P}-1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="aria2 appindicator control-socket +gnutls gstreamer libnotify nls openssl libressl rss"

PATCHES=(
	"${FILESDIR}/${PN}-fno-common-713812.diff"
)

REQUIRED_USE="^^ ( gnutls openssl )"

DEPEND="
	appindicator? ( dev-libs/libappindicator:3 )
	aria2? ( net-misc/aria2[xmlrpc] )
	>=dev-libs/glib-2.32:2
	dev-libs/libpcre
	gnutls? (
		net-libs/gnutls:=
		dev-libs/libgcrypt:0
	)
	gstreamer? ( media-libs/gstreamer:1.0 )
	libnotify? ( x11-libs/libnotify )
	>=net-misc/curl-7.19.1
	openssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	>=x11-libs/gtk+-3.4:3
	"

BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	"

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
