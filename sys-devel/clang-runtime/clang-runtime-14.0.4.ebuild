# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"

LICENSE="metapackage"
SLOT="$(ver_cut 1-3)"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+compiler-rt libcxx openmp +sanitize"
REQUIRED_USE="sanitize? ( compiler-rt )"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
		sanitize? (
			~sys-libs/compiler-rt-sanitizers-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
		)
	)
	libcxx? ( >=sys-libs/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-${PV}[${MULTILIB_USEDEP}] )
"
