# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..10} )

# Keep synced with tests/citeproc-test.py
TEST_SUITE_COMMIT="c3db429ab7c6b9b9ccaaa6d3c6bb9e503f0d7b11"

inherit distutils-r1 pypi

DESCRIPTION="Yet another Python CSL Processor"
HOMEPAGE="https://pypi.org/project/citeproc-py/"
SRC_URI+="
	test? (
		https://github.com/citation-style-language/test-suite/archive/${TEST_SUITE_COMMIT}.tar.gz
			-> ${PN}-test-suite-${TEST_SUITE_COMMIT}.tar.gz
	)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=app-text/rnc2rng-2.6.3[${PYTHON_USEDEP}]"
RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/stop_test_from_accessing_git-${PV}.patch" )

distutils_enable_tests nose

src_prepare() {
	default

	if use test ; then
		mv "${WORKDIR}/test-suite-${TEST_SUITE_COMMIT}" "${S}/tests/test-suite" || die
	fi
}

python_test() {
	nosetests -v --ignore-files=citeproc-test.py || die "Tests failed with ${EPYTHON}"
	${EPYTHON} tests/citeproc-test.py -vs || die "Tests failed with ${EPYTHON}"
}
