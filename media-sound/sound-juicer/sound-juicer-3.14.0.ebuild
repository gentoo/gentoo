# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="CD ripper for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/SoundJuicer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="flac test vorbis"

COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.4:3
	media-libs/libcanberra[gtk3]
	>=app-cdr/brasero-2.90
	sys-apps/dbus
	gnome-base/gsettings-desktop-schemas

	media-libs/libdiscid
	>=media-libs/musicbrainz-5.0.1:5

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[vorbis?]
	flac? ( media-plugins/gst-plugins-flac:1.0 )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[cdda,udev]
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	media-plugins/gst-plugins-meta:1.0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	>=app-text/scrollkeeper-0.3.5
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.3 )
"

src_prepare() {
	gnome2_src_prepare

	# FIXME: gst macros does not take GST_INSPECT override anymore but we need a
	# way to disable inspection due to gst-clutter always creating a GL context
	# which is forbidden in sandbox since it needs write access to
	# /dev/card*/dri
	sed -e "s|\(gstinspect=\).*|\1$(type -P true)|" \
		-i configure || die
}

src_configure() {
	gnome2_src_configure ITSTOOL="$(type -P true)"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if [ -z ${REPLACING_VERSIONS} ]; then
		ewarn "The list of audio encoding profiles in ${P} is non-customizable."
		ewarn "A possible workaround is to rip to flac using ${PN}, and convert to"
		ewarn "your desired format using a separate tool."
	fi
}
