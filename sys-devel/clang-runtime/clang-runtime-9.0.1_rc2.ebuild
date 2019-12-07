# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="$(ver_cut 1-3)"
KEYWORDS=""
IUSE="+compiler-rt libcxx openmp +sanitize"
REQUIRED_USE="sanitize? ( compiler-rt )"
PROPERTIES="live"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${SLOT}
		sanitize? ( ~sys-libs/compiler-rt-sanitizers-${PV}:${SLOT} )
	)
	libcxx? ( >=sys-libs/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-${PV}[${MULTILIB_USEDEP}] )"
