# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Serif/Sans/Monospace font packages"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

RDEPEND="|| (
		media-fonts/liberation-fonts
		media-fonts/dejavu
		media-fonts/croscorefonts
		media-fonts/droid
		media-fonts/freefont
		media-fonts/corefonts
	)"
