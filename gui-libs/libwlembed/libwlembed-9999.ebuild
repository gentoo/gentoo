# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit git-r3 meson python-any-r1

DESCRIPTION="A library for easily adding embedded Wayland compositor functionality"
HOMEPAGE="https://gitlab.xfce.org/kelnos/libwlembed"
EGIT_REPO_URI="https://gitlab.xfce.org/kelnos/libwlembed"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk gtk-doc +introspection"

DEPEND="
	>=dev-libs/glib-2.72
	>=dev-libs/wayland-1.20
	>=dev-util/wayland-scanner-1.20
	x11-libs/libxkbcommon
	gtk? (
		>=gui-libs/gtk-layer-shell-0.7.0
		>=x11-libs/gtk+-3.24:3[wayland]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.72.0 )
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	>=dev-libs/wayland-protocols-1.25
"
BDEPEND="
	${PYTHON_DEPS}
	dev-build/xfce4-dev-tools
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_feature gtk gtk3)
		$(meson_feature gtk gtk3-layer-shell)
		$(meson_use introspection)
		$(meson_use gtk-doc)
		-Dexamples=false
	)

	meson_src_configure
}
