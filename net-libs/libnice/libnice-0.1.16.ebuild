# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson multilib-minimal xdg

DESCRIPTION="An implementation of the Interactice Connectivity Establishment standard (ICE)"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+gnutls gtk-doc +introspection libressl test +upnp"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnutls? ( >=net-libs/gnutls-2.12.0:0=[${MULTILIB_USEDEP}] )
	!gnutls? (
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] ) )
	upnp? ( >=net-libs/gupnp-igd-0.2.4:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-am-1.10 )
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

multilib_src_configure() {
	local emesonargs=(
		-Dgstreamer=disabled
		$(meson_feature test tests)
		$(meson_feature upnp gupnp)
		-Dcrypto-library=$(usex gnutls gnutls openssl)
		-Dgtk_doc=$(multilib_native_usex gtk-doc enabled disabled)
		-Dintrospection=$(multilib_native_usex introspection enabled disabled)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
