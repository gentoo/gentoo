# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils xdg-utils

DESCRIPTION="A GTK2 image viewer, manga reader, and booru browser"
HOMEPAGE="https://github.com/ahodesuka/ahoviewer"
SRC_URI="https://github.com/ahodesuka/ahoviewer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnutls +gstreamer libsecret +rar +ssl +zip"

DEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/libconfig[cxx]
	dev-libs/libxml2:2
	dev-libs/libsigc++:2
	net-misc/curl
	gstreamer? (
		media-libs/gst-plugins-bad:1.0
		media-libs/gstreamer:1.0
	)
	libsecret? ( app-crypt/libsecret )
	rar? ( app-arch/unrar )
	ssl? (
		gnutls? (
			net-libs/gnutls:=
			net-misc/curl[curl_ssl_gnutls]
		)
		!gnutls? (
			>=dev-libs/openssl-1.0.0:0=
			net-misc/curl[curl_ssl_openssl]
		)
	)
	zip? ( dev-libs/libzip )
"
RDEPEND="
	${DEPEND}
	gstreamer? (
		media-libs/gst-plugins-base:1.0[X]
		media-libs/gst-plugins-good:1.0
		|| (
			media-plugins/gst-plugins-vpx
			media-plugins/gst-plugins-libav
		)
	)
"

src_prepare() {
	default
	xdg_environment_reset

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable gstreamer gst)
		$(use_enable libsecret)
		$(use_enable rar)
		$(use_enable zip)
	)

	if use ssl && use gnutls ; then
		myconf+=( --disable-ssl --enable-gnutls )
	elif use ssl && ! use gnutls ; then
		myconf+=( --enable-ssl --disable-gnutls )
	else
		myconf+=( --disable-ssl --disable-gnutls )
	fi

	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
