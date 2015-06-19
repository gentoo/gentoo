# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgit2/libgit2-0.18.0.ebuild,v 1.1 2013/04/21 06:22:09 radhermit Exp $

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="A linkable library for Git"
HOMEPAGE="http://libgit2.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"
IUSE="examples test"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
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
