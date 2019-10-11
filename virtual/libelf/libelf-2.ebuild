# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for libelf.so.0 provider dev-libs/libelf"
SLOT="0/0"
KEYWORDS="alpha amd64 arm arm64 hppa ~mips ppc ppc64 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/libelf-0.8.13-r2:0/0[${MULTILIB_USEDEP}]"
