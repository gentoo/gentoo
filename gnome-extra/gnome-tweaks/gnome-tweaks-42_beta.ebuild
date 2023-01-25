# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Customize advanced GNOME options"
HOMEPAGE="https://wiki.gnome.org/Apps/Tweaks"

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="${PYTHON_DEPS}"
# See README.md for list of deps
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.10.2:3[${PYTHON_USEDEP}]
	')
	>=gnome-base/gnome-settings-daemon-3
	x11-themes/sound-theme-freedesktop

	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.12:3[introspection]
	>=gnome-base/gnome-desktop-3.30:3[introspection]
	gui-libs/libhandy:1[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
	>=gnome-base/gsettings-desktop-schemas-40.0
	>=gnome-base/gnome-shell-3.24
	x11-wm/mutter
"
BDEPEND=">=sys-devel/gettext-0.19.8"

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}"/usr/bin/
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
