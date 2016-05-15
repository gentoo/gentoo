# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator virtualx

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="https://wiki.gnome.org/Projects/Rygel"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +introspection +sqlite tracker test transcode"

# The deps for tracker? and transcode? are just the earliest available
# version at the time of writing this ebuild
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libgee-0.8:0.8
	>=dev-libs/libxml2-2.7:2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/libmediaart-0.7:2.0
	media-plugins/gst-plugins-soup:1.0
	>=net-libs/gssdp-0.13
	>=net-libs/gupnp-0.20.14
	>=net-libs/gupnp-av-0.12.4
	>=net-libs/libsoup-2.44:2.4
	>=sys-apps/util-linux-2.20
	x11-misc/shared-mime-info
	introspection? ( >=dev-libs/gobject-introspection-1.33.4:= )
	sqlite? (
		>=dev-db/sqlite-3.5:3
		dev-libs/libunistring:=
	)
	tracker? ( >=app-misc/tracker-0.16:= )
	transcode? (
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	X? ( >=x11-libs/gtk+-3:3 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# Maintainer only
#	>=dev-lang/vala-0.22
#   dev-libs/libxslt

src_configure() {
	# We set xsltproc because man pages are provided by upstream
	# and we do not want to regenerate them automagically.
	gnome2_src_configure \
		XSLTPROC=$(type -P false) \
		--enable-gst-launch-plugin \
		--enable-mediathek-plugin \
		--with-media-engine=gstreamer \
		--enable-nls \
		$(use_enable introspection) \
		$(use_enable sqlite media-export-plugin) \
		$(use_enable test tests) \
		$(use_enable tracker tracker-plugin) \
		$(use_with X ui)
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! version_is_at_least 0.28.2-r1 ${REPLACING_VERSIONS}; then
		elog "This version stops forcing the automatical starting of"
		elog "rygel as upstream pretends. This way, it will honor the"
		elog "user settings at Sharing section in gnome-control-center."
		elog "If you desire to keep getting rygel autostarting always"
		elog "you will need to configure your desktop to do it."
	fi
}
