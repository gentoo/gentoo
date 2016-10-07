# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="libcxx openmp"

# compiler-rt is installed unconditionally
RDEPEND="
	libcxx? ( ~sys-libs/libcxx-${PV} )
	openmp? ( ~sys-libs/libomp-${PV} )"
