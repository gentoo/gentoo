# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# font eclass is inherited directly, since this package is a special case that
# would greatly complicate the fonts logic of xorg-3
XORG_TARBALL_SUFFIX="xz"
inherit font xorg-3 meson

DESCRIPTION="X.Org font encodings"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="x11-apps/mkfontscale"

# Override xorg-3's src_prepare
src_prepare() {
	default
}

src_configure() {
	local emesonargs=(
		-Dfontrootdir="${EPREFIX}"/usr/share/fonts
	)
	meson_src_configure
}
