# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="XML output extension to GCC"
HOMEPAGE="http://www.gccxml.org/"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

src_prepare() {
	# patch below taken from Debian
	sed -i \
		-e 's/xatexit.c//' \
		GCC/libiberty/CMakeLists.txt || die "sed failed"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		 -DGCCXML_DOC_DIR:STRING="share/doc/${PF}"
	)
	cmake-utils_src_configure
}
