# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="A linkable library for Git"
HOMEPAGE="https://libgit2.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos"
IUSE="examples ssh test threads trace"

RDEPEND="
	sys-libs/zlib
	net-libs/http-parser
	ssh? ( net-libs/libssh2 )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS CONTRIBUTING.md CONVENTIONS.md README.md )

PATCHES=( "${FILESDIR}"/${P}-skip-blame-test.patch )

src_prepare() {
	# skip online tests
	sed -i '/libgit2_clar/s/-ionline/-xonline/' CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		$(cmake-utils_use_build test CLAR)
		$(cmake-utils_use_enable trace TRACE)
		$(cmake-utils_use_use ssh SSH)
		$(cmake-utils_use threads THREADSAFE)
	)
	cmake-utils_src_configure
}

src_test() {
	if [[ ${EUID} -eq 0 ]] ; then
		# repo::iterator::fs_preserves_error fails if run as root
		# since root can still access dirs with 0000 perms
		ewarn "Skipping tests: non-root privileges are required for all tests to pass"
	else
		local TEST_VERBOSE=1
		cmake-utils_src_test
	fi
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		egit_clean examples
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
