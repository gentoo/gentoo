# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils flag-o-matic

DESCRIPTION="find unused include directives in C/C++ programs"
HOMEPAGE="https://github.com/include-what-you-use/include-what-you-use"
# picked from google drive
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-3.4*
	=sys-devel/clang-3.4*"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch_user
}

src_configure() {
	append-ldflags -L$(llvm-config --libdir)

	local mycmakeargs=(
		-DLLVM_PATH=$(llvm-config --libdir)
	)
	cmake-utils_src_configure
}
