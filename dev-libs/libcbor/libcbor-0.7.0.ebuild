# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-any-r1 cmake-utils

DESCRIPTION="CBOR protocol implementation for C and others"
HOMEPAGE="https://github.com/pjk/libcbor"
SRC_URI="https://github.com/PJK/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE="+custom-alloc doc test"

BDEPEND="
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/breathe[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-util/cmocka )
"

RESTRICT="!test? ( test )"

CMAKE_MAKEFILE_GENERATOR="emake"

python_check_deps() {
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" && \
		has_version "dev-python/breathe[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCBOR_CUSTOM_ALLOC=$(usex custom-alloc 'ON' 'OFF')
		-DWITH_TESTS=$(usex test 'ON' 'OFF')
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		pushd doc >/dev/null || die
		emake html man
		popd >/dev/null || die
	fi
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		dodoc -r doc/build/html
		doman doc/build/man/*
	fi
}
