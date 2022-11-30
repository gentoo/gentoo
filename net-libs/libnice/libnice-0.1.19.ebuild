# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson-multilib xdg

DESCRIPTION="An implementation of the Interactice Connectivity Establishment standard (ICE)"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+gnutls gtk-doc +introspection +upnp"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnutls? ( >=net-libs/gnutls-2.12.0:0=[${MULTILIB_USEDEP}] )
	!gnutls? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	upnp? ( >=net-libs/gupnp-igd-0.2.4:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
"

src_prepare() {
	default

	# Broken w/ network-sandbox on (bug #847844)
	sed -i -e '/test-set-port-range/d' tests/meson.build || die
}

multilib_src_configure() {
	# gstreamer plugin split off into media-plugins/gst-plugins-libnice
	local emesonargs=(
		-Dgstreamer=disabled
		-Dcrypto-library=$(usex gnutls gnutls openssl)
		$(meson_native_use_feature introspection)
		$(meson_feature upnp gupnp)
		$(meson_native_use_feature gtk-doc gtk_doc)
	)

	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
