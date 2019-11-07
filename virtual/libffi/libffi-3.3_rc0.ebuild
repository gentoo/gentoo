# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The purpose of this ebuild is to provide quick fallback if and when we need to
# switch back to internal copy of libffi from sys-devel/gcc.

EAPI=7

inherit multilib-build

DESCRIPTION="A virtual for the Foreign Function Interface implementation"
SLOT="0/7" # SONAME=libffi.so.7
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/libffi-3.3_rc0:0/7[${MULTILIB_USEDEP}]"
