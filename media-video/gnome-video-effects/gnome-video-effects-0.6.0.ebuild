# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson optfeature

DESCRIPTION="Effects for Cheese, the webcam video and picture application"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeVideoEffects"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"

DEPEND=""
RDEPEND=""
BDEPEND="
	>=sys-devel/gettext-0.17
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

pkg_postinst() {
	optfeature "Scanline video effect" media-plugins/frei0r-plugins
}
