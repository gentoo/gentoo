# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS=""
IUSE="+compiler-rt libcxx openmp +sanitize"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}
		sanitize? ( ~sys-libs/compiler-rt-sanitizers-${PV} )
	)
	libcxx? ( ~sys-libs/libcxx-${PV} )
	openmp? ( ~sys-libs/libomp-${PV} )"

REQUIRED_USE="sanitize? ( compiler-rt )"
