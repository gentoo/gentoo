# Copyright 2005-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_PACKAGE_NAME="util"
inherit xorg-3

DESCRIPTION="X.Org font utilities"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

XORG_CONFIGURE_OPTIONS=(
	--with-fontrootdir="${EPREFIX}"/usr/share/fonts
	--with-mapdir="${EPREFIX}"/usr/share/fonts/util
)
