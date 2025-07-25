# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# It's critical that we use RelWithDebInfo and not Release (which a user
# may set) because the upstream CMake sets a different library name (!)
# with Release.
CMAKE_BUILD_TYPE=RelWithDebInfo
PYTHON_COMPAT=( python3_{11..14} )
# Needed for docs, bug #8357553
PYTHON_REQ_USE="xml(+)"
inherit cmake flag-o-matic python-any-r1

TEST_PV="0.13.74"
DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="https://github.com/gdraheim/zziplib https://zziplib.sourceforge.net"
# Test data tarball generated with python ./zziptests.py -D -d /tmp/zziplib -v
SRC_URI="
	https://github.com/gdraheim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-${TEST_PV}-testdata.tar.xz )
"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="sdl test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	test? (
		app-arch/unzip
		app-arch/zip
	)
"
DEPEND="
	sys-libs/zlib
	sdl? ( media-libs/libsdl2 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	# This test assumes being built with automake (checks for .libs/x).
	sed -i -e 's/test_81000_zzshowme_check_sfx/skip_&/' test/zziptests.py || die
	cmake_src_prepare
}

src_configure() {
	# https://github.com/gdraheim/zziplib/commit/f3bfc0dd6663b7df272cc0cf17f48838ad724a2f#diff-b7b1e314614cf326c6e2b6eba1540682R100
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DZZIPSDL=$(usex sdl)
		-DBUILD_TESTS=$(usex test)
		-DZZIPTEST=$(usex test)
		-DZZIPDOCS=ON
		-DZZIPWRAP=OFF
	)

	cmake_src_configure
}

src_test() {
	cd "${S}" || die
	"${EPYTHON}" "${S}"/test/zziptests.py \
		--downloads=no \
		--verbose \
		--topsrcdir "${S}" \
		--bindir "$(realpath --relative-to="${S}" "${BUILD_DIR}"/bins)" \
		--downloaddir "${WORKDIR}"/${PN}-${TEST_PV}-testdata \
		--testdatadir "${T}"/testdata.d \
	|| die "Tests failed with ${EPYTHON}"
}
