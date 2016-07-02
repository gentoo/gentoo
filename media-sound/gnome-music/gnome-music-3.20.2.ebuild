# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit gnome2 python-r1

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.28:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=media-libs/grilo-0.3.0:0.3[introspection]
	media-libs/libmediaart:2.0
	>=x11-libs/gtk+-3.19.3:3[introspection]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	>=app-misc/tracker-1.7.1[introspection(+)]
	|| (
		app-misc/tracker[gstreamer]
		app-misc/tracker[ffmpeg]
	)
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	media-plugins/grilo-plugins:0.2[tracker]
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.26
	dev-util/itstool
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}
