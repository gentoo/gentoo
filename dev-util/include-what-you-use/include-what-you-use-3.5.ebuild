# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/include-what-you-use/include-what-you-use-3.5.ebuild,v 1.1 2014/11/30 18:03:40 slyfox Exp $

EAPI=5
inherit eutils cmake-utils flag-o-matic

DESCRIPTION="find unused include directives in C/C++ programs"
HOMEPAGE="https://code.google.com/p/include-what-you-use/"
SRC_URI="http://include-what-you-use.com/downloads/include-what-you-use-3.5.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-3.5*
	=sys-devel/clang-3.5*"
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
