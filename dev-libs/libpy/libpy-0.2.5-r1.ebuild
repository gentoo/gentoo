# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit flag-o-matic distutils-r1

GTEST_VER="23b2a3b1cf803999fb38175f6e9e038a4495c8a5"

DESCRIPTION="Utilities for writing C++ extension modules"
HOMEPAGE="https://quantopian.github.io/libpy/
	https://github.com/quantopian/libpy"
SRC_URI="
	https://github.com/quantopian/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/${GTEST_VER}.tar.gz -> gtest-${GTEST_VER}.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sparsehash test"

COMMON_DEPEND="
	>=dev-python/numpy-1.11.3[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${COMMON_DEPEND}
	sparsehash? ( dev-cpp/sparsehash )
	test? (
		dev-cpp/gtest
		>=dev-python/pytest-4.4.1[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( sparsehash )"

PATCHES=(
	"${FILESDIR}/libpy-0.2.5-no-werror.patch"
	"${FILESDIR}/libpy-0.2.5-permissions.patch"
	"${FILESDIR}/libpy-0.2.5-cflags.patch"
)

python_test() {
	emake GTEST_ROOT="${WORKDIR}/googletest-${GTEST_VER}" test
}

python_configure() {
	replace-flags '-O*' '-O3'
}
