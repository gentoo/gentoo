# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal xdg

DESCRIPTION="An implementation of the Interactice Connectivity Establishment standard (ICE)"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+gnutls +introspection libressl +upnp"

RDEPEND="
	>=dev-libs/glib-2.48:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnutls? ( >=net-libs/gnutls-2.12.0:0=[${MULTILIB_USEDEP}] )
	!gnutls? (
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] ) )
	upnp? ( >=net-libs/gupnp-igd-0.2.4:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-libressl.patch" ) # https://gitlab.freedesktop.org/libnice/libnice/merge_requests/50

multilib_src_configure() {
	# gstreamer plugin split off into media-plugins/gst-plugins-libnice
	ECONF_SOURCE=${S} \
	econf \
		--enable-compile-warnings=yes \
		--disable-static \
		--disable-static-plugins \
		--without-gstreamer \
		--without-gstreamer-0.10 \
		--with-crypto-library=$(usex gnutls gnutls openssl) \
		$(multilib_native_use_enable introspection) \
		$(use_enable upnp gupnp)

	if multilib_is_native_abi; then
		ln -s {"${S}"/,}docs/reference/libnice/html || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

multilib_src_test() {
	emake -j1 check
}
