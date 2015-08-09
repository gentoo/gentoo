# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="Media player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Videos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+introspection lirc nautilus +python test zeitgeist"
# see bug #359379
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	zeitgeist? ( introspection )
"

KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd"

# TODO:
# Cone (VLC) plugin needs someone with the right setup to test it
#
# FIXME:
# Automagic tracker-0.9.0
# Runtime dependency on gnome-session-2.91
RDEPEND="
	>=dev-libs/glib-2.35:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.11.5:3[introspection?]
	>=dev-libs/totem-pl-parser-3.10.1:0=[introspection?]
	>=dev-libs/libpeas-1.1.0[gtk]
	x11-libs/cairo
	>=dev-libs/libxml2-2.6:2
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-1.5.5:2.0
	>=media-libs/clutter-gtk-1.5.5:1.0
	x11-libs/mx:1.0

	>=media-libs/grilo-0.2.11:0.2[playlist]
	media-plugins/grilo-plugins:0.2
	>=media-libs/gstreamer-1.3.1:1.0
	>=media-libs/gst-plugins-base-1.4.2:1.0[X,introspection?,pango]
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-taglib:1.0
	media-plugins/gst-plugins-meta:1.0

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXxf86vm-1.0.1

	gnome-base/gnome-desktop:3
	gnome-base/gsettings-desktop-schemas
	x11-themes/gnome-icon-theme-symbolic

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.91.3 )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/libpeas-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=x11-libs/gtk+-3.5.2:3[introspection] )
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.12 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/scrollkeeper
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40
	sys-devel/gettext
	x11-proto/xextproto
	x11-proto/xproto
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs:
#	app-text/yelp-tools
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common
# docbook-xml-dtd is needed for user doc
# Prevent dev-python/pylint dep, bug #482538

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Prevent pylint usage by tests, bug #482538
	sed -i -e 's/ check-pylint//' src/plugins/Makefile.plugins || die

	eautoreconf
	gnome2_src_prepare

	# FIXME: upstream should provide a way to set GST_INSPECT, bug #358755 & co.
	# gst-inspect causes sandbox violations when a plugin needs write access to
	# /dev/dri/card* in its init phase.
	sed -e "s|\(gst10_inspect=\).*|\1$(type -P true)|" \
		-i configure || die
}

src_configure() {
	# Disabled: sample-python, sample-vala
	local plugins="apple-trailers,autoload-subtitles,brasero-disc-recorder"
	plugins+=",chapters,im-status,gromit,media-player-keys,ontop"
	plugins+=",properties,recent,rotation,screensaver,screenshot"
	plugins+=",skipto,vimeo"
	use lirc && plugins+=",lirc"
	use nautilus && plugins+=",save-file"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"
	use zeitgeist && plugins+=",zeitgeist-dp"

	# pylint is checked unconditionally, but is only used for make check
	# appstream-util overriding necessary until upstream fixes their macro
	# to respect configure switch
	gnome2_src_configure \
		--disable-run-in-source-tree \
		--disable-static \
		--enable-easy-codec-installation \
		--enable-vala \
		$(use_enable introspection) \
		$(use_enable nautilus) \
		$(use_enable python) \
		PYLINT=$(type -P true) \
		VALAC=$(type -P true) \
		APPSTREAM_UTIL=$(type -P true) \
		--with-plugins=${plugins}
}
