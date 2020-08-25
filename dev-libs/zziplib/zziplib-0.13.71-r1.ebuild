# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake flag-o-matic python-any-r1

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="https://github.com/gdraheim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0/13"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc sdl static-libs test"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		${PYTHON_DEPS}
	)
	test? (
		${PYTHON_DEPS}
		app-arch/zip
	)
"
DEPEND="
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.69-009-perror.patch
	"${FILESDIR}"/${PN}-0.13.71-join-paths-pc-zzipsdldir.patch
	"${FILESDIR}"/${PN}-0.13.71-find-bash.patch
	"${FILESDIR}"/${PN}-0.13.71-testbuilds-opensuse15-ninja-sdl2.patch
	"${FILESDIR}"/${PN}-0.13.71-shell-DESTDIR.patch
)

pkg_setup() {
	(use test || use doc) && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	(use test || use doc) && python_fix_shebang .
}

src_configure() {
	append-flags -fno-strict-aliasing # bug reported upstream

	append-cppflags -D_ZZIP_LARGEFILE
	local mycmakeargs=(
		-DZZIPCOMPAT=OFF
		-DZZIPSDL="$(usex sdl ON OFF)"
		-DBUILD_STATIC_LIBS="$(usex static-libs ON OFF)"
		-DBUILD_TESTS="$(usex test ON OFF)"
		-DZZIPTEST="$(usex test ON OFF)"
		-DZZIPDOCS="$(usex doc ON OFF)"
		-DZZIPWRAP=OFF
	)

	cmake_src_configure
}
