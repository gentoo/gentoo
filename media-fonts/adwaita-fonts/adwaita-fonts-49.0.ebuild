# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font gnome.org meson

DESCRIPTION="The typefaces for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-fonts"

LICENSE="OFL-1.1"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# Font eclass settings
FONT_SUFFIX="ttf"

src_configure() {
	local emesonargs=(
		-Ddatadir="${EPREFIX}/usr/share"
	)
	meson_src_configure
}
