# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-build

# Note: keep it matching clang-9999 version
CLANG_PV=5.0.0
DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="${CLANG_PV%%.*}"
KEYWORDS=""
IUSE="+compiler-rt libcxx openmp +sanitize"

RDEPEND="
	~sys-devel/clang-${PV}:${SLOT}
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${CLANG_PV}
		sanitize? ( ~sys-libs/compiler-rt-sanitizers-${PV}:${CLANG_PV} )
	)
	libcxx? ( >=sys-libs/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-${PV}[${MULTILIB_USEDEP}] )"

REQUIRED_USE="sanitize? ( compiler-rt )"
