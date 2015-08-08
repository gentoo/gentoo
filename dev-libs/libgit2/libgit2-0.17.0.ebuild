# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils multilib

DESCRIPTION="A linkable library for Git"
HOMEPAGE="http://libgit2.github.com/"
SRC_URI="mirror://github/${PN}/${PN}/${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"
IUSE="examples test"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( README.md )

PATCHES=( "${FILESDIR}"/${P}-cflags.patch )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB="${EPREFIX}/usr/$(get_libdir)"
		$(cmake-utils_use_build test CLAR)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		find examples -name .gitignore -delete
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
