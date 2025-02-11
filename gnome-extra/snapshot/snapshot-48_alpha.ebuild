# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo gnome2 meson xdg

DESCRIPTION="Take pictures and videos"
HOMEPAGE="https://gitlab.gnome.org/GNOME/snapshot"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT MPL-2.0 Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.75.0:2
	>=gui-libs/gtk-4.11.0
	>=gui-libs/libadwaita-1.7_alpha
	>=media-libs/gstreamer-1.20.0
	>=media-libs/gst-plugins-bad-1.20.0
	media-video/pipewire[camera]
"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-libs/gdk-pixbuf
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/${PN} usr/bin/${PN}-monitor"

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
