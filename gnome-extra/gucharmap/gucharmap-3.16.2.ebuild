# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://live.gnome.org/Gucharmap"

LICENSE="GPL-3"
SLOT="2.90"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="cjk +introspection test vala"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/pango-1.2.1[introspection?]
	>=x11-libs/gtk+-3.16:3[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gucharmap-3:0
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/desktop-file-utils
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	test? (	app-text/docbook-xml-dtd:4.1.2 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	# prevent file collisions with slot 0
	sed -e "s:GETTEXT_PACKAGE=gucharmap$:GETTEXT_PACKAGE=gucharmap-${SLOT}:" \
		-i configure.ac configure || die "sed configure.ac configure failed"

	# avoid autoreconf
	sed -e 's/-Wall //g' -i configure || die "sed failed"

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Do not add ITSTOOL=$(type -P true); yelp-tools is a true required
	# dependency here for some LINGUAS.
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable cjk unihan) \
		$(use_enable vala)
}
