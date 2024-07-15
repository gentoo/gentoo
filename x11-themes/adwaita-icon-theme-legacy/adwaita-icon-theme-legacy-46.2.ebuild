# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="Adwaita Icon Theme legacy"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-icon-theme-legacy"

LICENSE="LGPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

# gtk+:3 is needed for build for the gtk-encode-symbolic-svg utility
# librsvg is needed for gtk-encode-symbolic-svg to be able to read the source SVG via
# its pixbuf loader and at runtime for rendering scalable icons shipped by the theme
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
RDEPEND="${DEPEND}
	>=gnome-base/librsvg-2.48:2
"
BDEPEND="
	>=gnome-base/librsvg-2.48:2
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gtk+:3
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_test() {
	:; # No tests
}

src_install() {
	meson_src_install
	# https://gitlab.gnome.org/GNOME/adwaita-icon-theme-legacy/-/issues/3
	mv "${D}"/usr/share/licenses/adwaita-icon-theme \
		"${D}"/usr/share/licenses/adwaita-icon-theme-legacy || die
}
