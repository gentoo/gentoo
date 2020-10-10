# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake flag-o-matic python-any-r1

MY_COMMIT="3921fc43bca7283f126bfb2e47ec7e7e24b5a5ea" # master Oct 21, 2020
DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="https://github.com/gdraheim/zziplib http://zziplib.sourceforge.net/"
SRC_URI="https://github.com/gdraheim/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="sdl static-libs"

# Tests require internet access
# https://github.com/gdraheim/zziplib/issues/24

BDEPEND="
	${PYTHON_DEPS}
"
DEPEND="
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.71-reorganize-ZZIP_OPTIONFLAGS.patch # https://github.com/gdraheim/zziplib/commit/5583ccc
	"${FILESDIR}"/${PN}-0.13.71-58_manvolnum_should_be_in_.so.patch	# https://github.com/gdraheim/zziplib/commit/03ddd0c
	"${FILESDIR}"/${PN}-0.13.71-copy_directory_instead_of_unpacking.patch # https://github.com/gdraheim/zziplib/commit/31d8a95
	"${FILESDIR}"/${PN}-0.13.71-installing-man3-pages.patch # https://github.com/gdraheim/zziplib/issues/93#issuecomment-616219417
)

src_configure() {
	# https://github.com/gdraheim/zziplib/commit/f3bfc0dd6663b7df272cc0cf17f48838ad724a2f#diff-b7b1e314614cf326c6e2b6eba1540682R100
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DZZIPSDL="$(usex sdl)"
		-DBUILD_STATIC_LIBS="$(usex static-libs)"
		-DBUILD_TESTS=OFF
		-DZZIPTEST=OFF
		-DZZIPDOCS=ON
		-DZZIPWRAP=OFF
	)

	cmake_src_configure
}
