# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

UPLOADHASH="7578eee7df552d1f9b995120100959a2"
DESCRIPTION="Fragments is an easy to use BitTorrent client"
HOMEPAGE="https://gitlab.gnome.org/World/Fragments"
SRC_URI="https://gitlab.gnome.org/World/${PN}/uploads/${UPLOADHASH}/${P}.tar.xz"
BUILD_DIR="${S}/build"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 GPL-3+ MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib
	dev-libs/openssl:=
	gui-libs/gtk
	gui-libs/libadwaita
	net-p2p/transmission
	sys-apps/dbus
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/rust
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
