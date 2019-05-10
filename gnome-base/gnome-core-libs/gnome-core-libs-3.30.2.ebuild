# Copyright 1999-2019 Gentoo Authors
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
	>=dev-libs/glib-2.58.1:2
	>=x11-libs/gdk-pixbuf-2.38.0:2
	>=x11-libs/pango-1.42.4
	>=x11-libs/gtk+-3.24.1:3[cups?]
	>=dev-libs/atk-2.30.0
	>=gnome-base/librsvg-2.40.20
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.38.1
	>=gnome-base/dconf-0.30.1

	>=media-libs/gstreamer-1.14.4:1.0
	>=media-libs/gst-plugins-base-1.14.4:1.0
	>=media-libs/gst-plugins-good-1.14.4:1.0

	python? ( >=dev-python/pygobject-3.30.1:3 )
"
DEPEND=""

# >=x11-libs/libwnck-3.24.1:3 - not used by core packages anymore
# librsvg kept back on non-rust version; should move on at some point for non-exotic arches.

S="${WORKDIR}"
