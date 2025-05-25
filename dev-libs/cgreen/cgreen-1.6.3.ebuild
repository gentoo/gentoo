# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Unit test and mocking framework for C and C++"
HOMEPAGE="
	https://cgreen-devs.github.io/cgreen/
	https://github.com/cgreen-devs/cgreen
"
SRC_URI="https://github.com/cgreen-devs/cgreen/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libxml2 test xml" # doc flag could be added
RESTRICT="!test? ( test )"

DEPEND="libxml2? ( dev-libs/libxml2:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	${DEPEND}
	test? (	dev-lang/perl )
"

PATCHES=( "${FILESDIR}"/${PN}-1.6.3_no-fortify-source.patch )

src_configure() {
	# Makefile is a wrapper for cmake, ignore it
	filter-lto # fails to compile with LTO because of ODR violation
	local mycmakeargs=(
		-DCGREEN_WITH_STATIC_LIBRARY=OFF # upstream default
		-DCGREEN_WITH_LIBXML2=$(usex libxml2 ON OFF)
		-DCGREEN_WITH_UNIT_TESTS=$(usex test ON OFF)
		-DCGREEN_WITH_XML=$(usex xml ON OFF)
	)
	cmake_src_configure
}
