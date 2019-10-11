# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for the pkg-config implementation"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		>=dev-util/pkgconfig-0.28-r1[${MULTILIB_USEDEP}]
		>=dev-util/pkgconf-0.9.12[pkg-config,${MULTILIB_USEDEP}]
		>=dev-util/pkgconfig-openbsd-20130507-r1[pkg-config,${MULTILIB_USEDEP}]
	)"
