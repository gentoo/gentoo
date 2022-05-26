# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core libraries of GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME
RDEPEND="
	>=dev-libs/glib-2.70.2:2
	>=x11-libs/gdk-pixbuf-2.42.6:2
	>=x11-libs/pango-1.48.10
	>=x11-libs/gtk+-3.24.31:3[cups?]
	>=dev-libs/atk-2.36.0
	>=gnome-base/librsvg-2.52.5
	>=gnome-base/gnome-desktop-${PV}:3

	>=gnome-base/gvfs-1.48.1
	>=gnome-base/dconf-0.40.0

	>=media-libs/gstreamer-1.16.2:1.0
	>=media-libs/gst-plugins-base-1.16.2:1.0
	>=media-libs/gst-plugins-good-1.16.2:1.0

	python? ( >=dev-python/pygobject-3.42.0:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
