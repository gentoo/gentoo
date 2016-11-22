# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils flag-o-matic

WEIRD_UPSTREAM_VERSION=0.6

DESCRIPTION="find unused include directives in C/C++ programs"
HOMEPAGE="http://include-what-you-use.org/"
SRC_URI="http://include-what-you-use.org/downloads/${PN}-${WEIRD_UPSTREAM_VERSION}.src.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-3.8*
	=sys-devel/clang-3.8*
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_configure() {
	append-libs -L$(llvm-config --libdir)

	local mycmakeargs=(
		-DLLVM_PATH=$(llvm-config --libdir)
	)
	cmake-utils_src_configure
}
