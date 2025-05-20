# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1

DESCRIPTION="Run Google Test suites in parallel."
HOMEPAGE="https://github.com/google/gtest-parallel"
MY_COMMIT="f4d65b555894b301699c7c3c52906f72ea052e83"
SRC_URI="
	https://github.com/google/gtest-parallel/archive/${MY_COMMIT}.tar.gz
		-> ${PN}-${MY_COMMIT}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${PYTHON_DEPS}"

src_test() {
	python_foreach_impl eunittest -p '*_tests.py'
}

src_install() {
	python_foreach_impl python_doexe gtest-parallel
	python_foreach_impl python_domodule gtest_parallel.py
	einstalldocs
}
