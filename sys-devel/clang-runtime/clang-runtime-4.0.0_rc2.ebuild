# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="${PV%_*}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+compiler-rt libcxx openmp +sanitize"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${SLOT}
		sanitize? ( ~sys-libs/compiler-rt-sanitizers-${PV}:${SLOT} )
	)
	libcxx? ( >=sys-libs/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=sys-libs/libomp-${PV}[${MULTILIB_USEDEP}] )"

REQUIRED_USE="sanitize? ( compiler-rt )"
