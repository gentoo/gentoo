# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo gnome2 meson xdg

DESCRIPTION="An image viewer application written with GTK 4, Libadwaita and Rust."
HOMEPAGE="https://apps.gnome.org/Loupe/ https://gitlab.gnome.org/GNOME/loupe"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD LGPL-2.1 MIT
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

RDEPEND="
	>=gui-libs/gtk-4.11.3[X?]
	>=gui-libs/libadwaita-1.4_alpha
	>=dev-libs/libgweather-4.0.0
	>=media-libs/lcms-2.12.0
	>=media-libs/glycin-loaders-1.0_beta
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0
	x11-libs/gdk-pixbuf
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/${PN} usr/bin/${PN}-monitor"

ECARGO_VENDOR=${S}/vendor

src_configure() {
	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	xdg_icon_cache_update
}
