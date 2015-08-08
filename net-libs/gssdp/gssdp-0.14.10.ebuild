# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal vala

DESCRIPTION="A GObject-based API for handling resource discovery and announcement over SSDP"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="+introspection +gtk"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.44.2:2.4[${MULTILIB_USEDEP},introspection?]
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	introspection? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-0.6.7 )
	!<net-libs/gupnp-vala-0.10.3
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	# Disable functional test as it requires port that might be used by rygel to
	# be free of use
	sed 's/\(check_PROGRAMS.*\)test-functional$(EXEEXT)/\1/' \
		-i "${S}"/tests/gtest/Makefile.in || die

	use introspection && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_with gtk) \
		--disable-static

	if multilib_is_native_abi; then
		# fix gtk-doc
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}
