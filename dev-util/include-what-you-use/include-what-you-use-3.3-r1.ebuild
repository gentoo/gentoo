# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/include-what-you-use/include-what-you-use-3.3-r1.ebuild,v 1.2 2013/10/03 06:17:19 slyfox Exp $

EAPI=5
inherit eutils cmake-utils flag-o-matic

DESCRIPTION="find unused include directives in C/C++ programs"
HOMEPAGE="https://code.google.com/p/include-what-you-use/"
# picked from google drive
SRC_URI="http://dev.gentoo.org/~slyfox/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-3.3*
	=sys-devel/clang-3.3*"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-issue-110-elaboration.patch
	epatch_user
}

src_configure() {
	append-ldflags -L$(llvm-config --libdir)

	local mycmakeargs=(
		-DLLVM_PATH=$(llvm-config --libdir)
	)
	cmake-utils_src_configure
}
