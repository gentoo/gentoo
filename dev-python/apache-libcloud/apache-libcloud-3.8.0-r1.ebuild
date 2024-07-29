# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="
	https://libcloud.apache.org/
	https://github.com/apache/libcloud/
	https://pypi.org/project/apache-libcloud/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="examples"

RDEPEND="
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/cryptography-2.6.1[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/apache/libcloud/pull/2014
		"${FILESDIR}/${P}-pytest-8.2.patch"
	)

	distutils-r1_src_prepare

	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi

	# needed for tests
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		libcloud/test/test_init.py::TestUtils::test_init_once_and_debug_mode
	)

	local -x NO_INTERNET=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

src_install() {
	use examples && dodoc -r examples
	distutils-r1_src_install
}
