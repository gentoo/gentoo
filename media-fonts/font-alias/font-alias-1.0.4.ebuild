# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_PACKAGE_NAME="alias"
inherit xorg-3

DESCRIPTION="X.Org font aliases"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"

XORG_CONFIGURE_OPTIONS=(
	# https://bugs.gentoo.org/815520
	--with-fontrootdir="${EPREFIX}"/usr/share/fonts
)
