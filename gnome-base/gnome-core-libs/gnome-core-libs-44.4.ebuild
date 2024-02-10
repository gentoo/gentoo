# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core libraries of GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME
RDEPEND="
	>=dev-libs/glib-2.76.4:2
	>=x11-libs/gdk-pixbuf-2.42.10:2
	>=x11-libs/pango-1.50.14
	>=x11-libs/gtk+-3.24.38:3[cups?]
	>=gui-libs/gtk-4.10.5:4[cups?]
	>=gui-libs/libadwaita-1.3.4:1
	>=app-accessibility/at-spi2-core-2.48.3:2
	>=gnome-base/librsvg-2.56.3
	>=gnome-base/gnome-desktop-44.0:4

	>=gnome-base/gvfs-1.50.6
	>=gnome-base/dconf-0.40.0

	>=media-libs/gstreamer-1.20.6:1.0
	>=media-libs/gst-plugins-base-1.20.6:1.0
	>=media-libs/gst-plugins-good-1.20.6:1.0

	python? ( >=dev-python/pygobject-3.44.1:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
