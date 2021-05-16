# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
GNOME2_LA_PUNT="yes"

inherit bash-completion-r1 gnome2 python-r1

DESCRIPTION="SDK for making video editors and more"
HOMEPAGE="http://wiki.pitivi.org/wiki/GES"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="amd64 x86"

IUSE="+introspection"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.40.0:2
	dev-libs/libxml2:2
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/gtk-doc-am-1.3
	virtual/pkgconfig
"
# XXX: tests do pass but need g-e-s to be installed due to missing
# AM_TEST_ENVIRONMENT setup.
RESTRICT="test"

src_prepare() {
	gnome2_src_prepare
	# Install python overrides manually for each python and old upstream
	# autotools code prefers python2 and installs in wrong location
	sed -e '/WITH_PYTHON/d' -i bindings/Makefile.in || die
}

src_configure() {
	# gtk is only used for examples
	gnome2_src_configure \
		$(use_enable introspection) \
		--disable-examples \
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

src_install() {
	gnome2_src_install
	python_moduleinto gi.overrides
	python_foreach_impl python_domodule bindings/python/gi/overrides/GES.py
}
