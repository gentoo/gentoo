# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature xdg

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="https://github.com/ugetdm/uget"
SRC_URI="https://downloads.sourceforge.net/project/urlget/uget%20%28stable%29/${PV}/${P}-1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="appindicator control-socket gstreamer libnotify nls openssl rss"

RDEPEND="
	dev-libs/glib:2
	net-misc/curl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	appindicator? ( dev-libs/libayatana-appindicator )
	gstreamer? ( media-libs/gstreamer:1.0 )
	libnotify? ( x11-libs/libnotify )
	!openssl? ( dev-libs/libgcrypt:0= )
	openssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-fno-common.patch
	# https://github.com/ugetdm/uget/issues/49
	"${FILESDIR}"/${PN}-2.2.1-ayatana.patch
	"${FILESDIR}"/${PN}-2.2.3-broken-curl-check.patch
	# https://github.com/ugetdm/uget/issues/40
	"${FILESDIR}"/${PN}-2.2.3-fix_crash_sorting.patch
	"${FILESDIR}"/${PN}-2.2.3-fix_c23.patch
)

src_prepare() {
	default
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
		$(use_with !openssl gnutls)
		$(use_with openssl)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "aria2 plugin" net-misc/aria2[xmlrpc]
}
