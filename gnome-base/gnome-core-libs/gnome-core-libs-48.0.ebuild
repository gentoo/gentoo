# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core libraries of GNOME"
HOMEPAGE="https://www.gnome.org/"

S="${WORKDIR}"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

IUSE="cups python"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME
DEPEND=""
RDEPEND="
	>=dev-libs/glib-2.84:2
	>=x11-libs/gdk-pixbuf-2.42.12:2
	>=x11-libs/pango-1.56
	>=x11-libs/gtk+-3.24.50:3[cups?]
	>=gui-libs/gtk-4.18:4[cups?]
	>=gui-libs/libadwaita-1.7:1
	>=app-accessibility/at-spi2-core-2.56:2
	>=gnome-base/librsvg-2.60
	>=gnome-base/gnome-desktop-44.3:4

	>=gnome-base/gvfs-1.56.1
	>=gnome-base/dconf-0.40.0

	>=media-libs/gstreamer-1.24.11:1.0
	>=media-libs/gst-plugins-base-1.24.11:1.0
	>=media-libs/gst-plugins-good-1.24.11:1.0

	python? ( >=dev-python/pygobject-3.50.0:3 )
"
BDEPEND=""
