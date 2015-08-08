# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils flag-o-matic

WEIRD_UPSREAM_VERSION=0.4

DESCRIPTION="find unused include directives in C/C++ programs"
HOMEPAGE="https://code.google.com/p/include-what-you-use/"
SRC_URI="http://include-what-you-use.org/downloads/${PN}-${WEIRD_UPSREAM_VERSION}.src.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-3.6*
	=sys-devel/clang-3.6*"
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
