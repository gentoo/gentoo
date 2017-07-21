# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.50.2:2
	>=x11-libs/gdk-pixbuf-2.36.0:2
	>=x11-libs/pango-1.40.3
	>=media-libs/clutter-1.26.0:1.0
	>=x11-libs/gtk+-3.22.3:3[cups?]
	>=dev-libs/atk-2.22.0
	>=gnome-base/librsvg-2.40.16
	>=gnome-base/gnome-desktop-3.22.2:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.30.2
	>=gnome-base/dconf-0.26.0

	>=media-libs/gstreamer-1.8.3:1.0
	>=media-libs/gst-plugins-base-1.8.3:1.0
	>=media-libs/gst-plugins-good-1.8.3:1.0

	python? ( >=dev-python/pygobject-3.22.0:3 )
"
DEPEND=""

# >=x11-libs/libwnck-3.20.1:3 - not used by core packages anymore

S="${WORKDIR}"
