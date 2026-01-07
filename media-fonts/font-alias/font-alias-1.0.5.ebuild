# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
XORG_PACKAGE_NAME="alias"
inherit xorg-3

DESCRIPTION="X.Org font aliases"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"

XORG_CONFIGURE_OPTIONS=(
	# https://bugs.gentoo.org/815520
	--with-fontrootdir="${EPREFIX}"/usr/share/fonts
)
