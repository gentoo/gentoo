# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gstreamer

DESCRIPTION="A GStreamer based RTSP server"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"

LICENSE="LGPL-2+"
KEYWORDS="amd64 x86"
IUSE="examples +introspection static-libs test"
RESTRICT="!test? ( test )"

# gst-plugins-base for many used elements and API
# gst-plugins-good for rtprtxsend and rtpbin elements, maybe more
# gst-plugins-srtp for srtpenc and srtpdec elements
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-srtp-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

# Due to gstreamer src_configure
QA_CONFIGURE_OPTIONS="--enable-nls"

multilib_src_configure() {
	# debug: only adds -g to CFLAGS
	# docbook: nothing behind that switch
	# libcgroup is automagic and only used in examples
	gstreamer_multilib_src_configure \
		--disable-debug \
		--disable-valgrind \
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
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*.c
	fi
}
