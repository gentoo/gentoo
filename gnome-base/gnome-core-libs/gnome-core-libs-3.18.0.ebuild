# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.46:2
	>=x11-libs/gdk-pixbuf-2.32:2
	>=x11-libs/pango-1.38
	>=media-libs/clutter-1.24:1.0
	>=x11-libs/gtk+-${PV}:3[cups?]
	>=dev-libs/atk-2.18
	>=x11-libs/libwnck-3.14:3
	>=gnome-base/librsvg-2.40.10
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.26
	>=gnome-base/dconf-0.24

	|| (
		>=media-libs/gstreamer-0.10.36:0.10
		>=media-libs/gstreamer-1.6.1:1.0 )
	|| (
		>=media-libs/gst-plugins-base-0.10.36:0.10
		>=media-libs/gst-plugins-base-1.6.1:1.0 )
	|| (
		>=media-libs/gst-plugins-good-0.10.31:0.10
		>=media-libs/gst-plugins-good-1.6.1:1.0 )

	python? ( >=dev-python/pygobject-${PV}:3 )
"
DEPEND=""

S="${WORKDIR}"
