# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for libelf.so.1 provider dev-libs/elfutils"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	|| (
		>=dev-libs/elfutils-0.155-r1:0/0[${MULTILIB_USEDEP}]
		>=sys-freebsd/freebsd-lib-9.2_rc1[${MULTILIB_USEDEP}]
	)"
