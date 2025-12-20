# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for OpenGL implementation"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="X"

RDEPEND="
	|| (
		media-libs/libglvnd[X?,${MULTILIB_USEDEP}]
		dev-util/mingw64-runtime
	)"
