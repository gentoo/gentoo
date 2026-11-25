# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALGLIB_SOVER=$(ver_cut 1-2)
inherit cmake flag-o-matic

DESCRIPTION="Numerical analysis and data processing library"
HOMEPAGE="https://www.alglib.net/"
SRC_URI="https://www.alglib.net/translator/re/${P}.cpp.gpl.tgz"
S="${WORKDIR}"/${PN}-cpp

LICENSE="GPL-2+"
SLOT="0/${ALGLIB_SOVER}"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=dev-build/cmake-3.31"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt-3.20.0 CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# bug #862666
	append-flags -fno-strict-aliasing
	filter-lto

	use x86 && append-cflags -ffloat-store

	local mycmakeargs=(
		-DALGLIB_VERSION=${PV}
		-DALGLIB_SOVERSION=${ALGLIB_SOVER}
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
