# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit bash-completion-r1 gnome2

DESCRIPTION="SDK for making video editors and more"
HOMEPAGE="http://wiki.pitivi.org/wiki/GES"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="amd64 ~x86"
IUSE="+introspection"

# FIXME: There is something odd with pygobject check for >=4.22,
#        check with upstream
COMMON_DEPEND="
	>=dev-libs/glib-2.34:2
	dev-libs/libxml2:2
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
RDEPEND="${COMMON_DEPEND}
	media-libs/gnonlin:1.0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.3
	virtual/pkgconfig
"
# XXX: tests do pass but need g-e-s to be installed due to missing
# AM_TEST_ENVIRONMENT setup.
RESTRICT="test"

src_configure() {
	# gtk is only used for examples
	gnome2_src_configure \
		$(use_enable introspection) \
		--disable-examples \
		--without-gtk \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		--with-package-name="GStreamer editing services ebuild for Gentoo" \
		--with-package-origin="https://packages.gentoo.org/package/media-libs/gstreamer-editing-services"
}

src_compile() {
	# Prevent sandbox violations, bug #538888
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	addpredict /dev
	gnome2_src_compile
}
