# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# font eclass is inherited directly, since this package is a special case that
# would greatly complicate the fonts logic of xorg-3
XORG_TARBALL_SUFFIX="xz"
inherit font xorg-3

DESCRIPTION="X.Org font encodings"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"

XORG_CONFIGURE_OPTIONS=(
	# https://bugs.gentoo.org/815520
	--with-fontrootdir="${EPREFIX}"/usr/share/fonts
)
