# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for the pkg-config implementation"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		>=dev-util/pkgconf-1.3.7[pkg-config,${MULTILIB_USEDEP}]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
		>=dev-util/pkgconfig-openbsd-20130507-r2[pkg-config,${MULTILIB_USEDEP}]
	)"
