# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core libraries of GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME
RDEPEND="
	>=dev-libs/glib-2.78.1:2
	>=x11-libs/gdk-pixbuf-2.42.10:2
	>=x11-libs/pango-1.51.0
	>=x11-libs/gtk+-3.24.38:3[cups?]
	>=gui-libs/gtk-4.12.4:4[cups?]
	>=gui-libs/libadwaita-1.4.2:1
	>=app-accessibility/at-spi2-core-2.50.0:2
	>=gnome-base/librsvg-2.57.0
	>=gnome-base/gnome-desktop-44.0:4

	>=gnome-base/gvfs-1.52.1
	>=gnome-base/dconf-0.40.0

	>=media-libs/gstreamer-1.22.3:1.0
	>=media-libs/gst-plugins-base-1.22.3:1.0
	>=media-libs/gst-plugins-good-1.22.3:1.0

	python? ( >=dev-python/pygobject-3.46.0:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
