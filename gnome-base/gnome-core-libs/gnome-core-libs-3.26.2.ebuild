# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.54.2:2
	>=x11-libs/gdk-pixbuf-2.36.11:2
	>=x11-libs/pango-1.40.13
	>=x11-libs/gtk+-3.22.25:3[cups?]
	>=dev-libs/atk-2.26.1
	>=gnome-base/librsvg-2.40.19
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.34.1
	>=gnome-base/dconf-0.26.1

	>=media-libs/gstreamer-1.14.1:1.0
	>=media-libs/gst-plugins-base-1.14.1:1.0
	>=media-libs/gst-plugins-good-1.14.1:1.0

	python? ( >=dev-python/pygobject-3.26.1:3 )
"
DEPEND=""

# >=x11-libs/libwnck-3.24.1:3 - not used by core packages anymore

S="${WORKDIR}"
