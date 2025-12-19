# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for SSH client and server"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	minimal? (
		|| ( net-misc/dropbear virtual/openssh )
	)
	!minimal? (
		|| ( virtual/openssh net-misc/dropbear )
	)"
