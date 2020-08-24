# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake flag-o-matic python-any-r1

MY_COMMIT="223930775aa5b325f04cec01f0b18726a7918821"

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="https://github.com/gdraheim/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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

S="${WORKDIR}/${PN}-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.69-009-perror.patch
	"${FILESDIR}"/${PN}-0.13.71-installing-man3-pages.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	append-flags -fno-strict-aliasing # bug reported upstream

	local mycmakeargs=(
		-DZZIPSDL="$(usex sdl)"
		-DBUILD_STATIC_LIBS="$(usex static-libs)"
		-DBUILD_TESTS="$(usex test)"
		-DZZIPTEST="$(usex test)"
		-DZZIPDOCS="$(usex doc)"
		-DZZIPWRAP=OFF
	)

	cmake_src_configure
}
