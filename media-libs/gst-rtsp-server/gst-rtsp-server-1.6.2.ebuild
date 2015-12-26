# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gstreamer

DESCRIPTION="A GStreamer based RTSP server"
HOMEPAGE="http://people.freedesktop.org/~wtay/"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples +introspection static-libs test"

# FIXME: check should depend on USE=test but check is losy
# configure says good and bad are required by macros forces them to be optional
# they are only used in unittests anyway.
RDEPEND="
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
DEPEND="${RDEPEND}
	>=dev-libs/check-0.9.2
	>=dev-util/gtk-doc-am-1.12
	virtual/pkgconfig
	test? (
		>=media-libs/gst-plugins-bad-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-good-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	)
"

# Due to gstreamer src_configure
QA_CONFIGURE_OPTIONS="--enable-nls"

multilib_src_configure() {
	# debug: only adds -g to CFLAGS
	# docbook: nothing behind that switch
	# libcgroup is automagic and only used in examples
	gstreamer_multilib_src_configure \
		--disable-examples \
		--disable-docbook \
		--disable-gtk-doc \
		$(multilib_native_use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		LIBCGROUP_LIBS= \
		LIBCGROUP_FLAGS=

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi ; then
		ln -s "${S}"/docs/libs/${d}/html docs/libs/${d}/html || die
	fi
}

multilib_src_install() {
	emake install DESTDIR="${D}"
	# Handle broken upstream modifications to defaults of gtk-doc
	emake install -C docs/libs DESTDIR="${D}"
	prune_libtool_files
}

multilib_src_install_all() {
	einstalldocs

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*.c
	fi
}
