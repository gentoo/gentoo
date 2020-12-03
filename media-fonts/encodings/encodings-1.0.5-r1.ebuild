# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# font eclass is inherited directly, since this package is a special case that
# would greatly complicate the fonts logic of xorg-3
inherit font xorg-3

DESCRIPTION="X.Org font encodings"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"
