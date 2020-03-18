# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="${PV%_*}"
KEYWORDS="amd64 arm arm64 ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+compiler-rt crt libcxx openmp +sanitize"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${SLOT}
		sanitize? ( ~sys-libs/compiler-rt-sanitizers-${PV}:${SLOT} )
	)
	crt? (
		|| (
			sys-libs/netbsd-csu[${MULTILIB_USEDEP}]
			sys-freebsd/freebsd-lib[${MULTILIB_USEDEP}]
		)
	)
	libcxx? ( >=sys-libs/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-${PV}[${MULTILIB_USEDEP}] )"

REQUIRED_USE="sanitize? ( compiler-rt )"
