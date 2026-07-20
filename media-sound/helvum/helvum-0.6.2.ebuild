# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..19} )
RUST_MIN_VER="1.94"
inherit cargo desktop llvm-r2 xdg

DESCRIPTION="A GTK patchbay for pipewire"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/helvum"
SRC_URI="
	https://gitlab.freedesktop.org/pipewire/helvum/-/archive/${PV}/${P}.tar.bz2
	https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT
	Unicode-3.0 Unlicense
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Clang needed for bindgen
BDEPEND="
	>=dev-build/meson-1.8.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/glib-2.84.0:2
	>=gui-libs/gtk-4.18.0:4
	>=gui-libs/libadwaita-1.7:1
	media-libs/graphene
	>=media-video/pipewire-1.4:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_setup() {
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_install() {
	cargo_src_install

	dodoc README.md

	doicon --size scalable data/icons/org.pipewire.Helvum.svg

	insopts -m 0644
	insinto /usr/share/icons/hicolor/symbolic/apps
	doins data/icons/org.pipewire.Helvum-symbolic.svg

	make_desktop_entry "${PN}" Helvum org.pipewire.Helvum \
		"AudioVideo;Audio;Video;Midi;Settings;GNOME;GTK" "Terminal=false\nGenericName=Patchbay"
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}
