# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="Adwaita Icon Theme legacy"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-icon-theme-legacy"

LICENSE="LGPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# librsvg > 2.40 or gtk >= 4.22 are needed at runtime for rendering scalable
# icons shipped by the theme: https://viruta.org/do-not-use-librsvg-2.40.x.html
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
RDEPEND="${DEPEND}
	|| ( >=gui-libs/gtk-4.22 >=gnome-base/librsvg-2.48:2 )
"
BDEPEND="
	dev-util/gtk-update-icon-cache
	sys-devel/gettext
	virtual/pkgconfig
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_test() {
	:; # No tests
}

src_install() {
	meson_src_install
	# https://gitlab.gnome.org/GNOME/adwaita-icon-theme-legacy/-/issues/3
	mv "${ED}"/usr/share/licenses/adwaita-icon-theme \
		"${ED}"/usr/share/licenses/adwaita-icon-theme-legacy || die
}
