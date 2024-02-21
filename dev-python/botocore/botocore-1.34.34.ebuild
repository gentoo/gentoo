# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Low-level, data-driven core of boto 3"
HOMEPAGE="
	https://github.com/boto/botocore/
	https://pypi.org/project/botocore/
"
SRC_URI="
	https://github.com/boto/botocore/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	<dev-python/jmespath-2[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# unpin deps
	sed -i -e "s:>=.*':':" setup.py || die

	# unbundle deps
	rm -r botocore/vendored || die
	find -name '*.py' -exec sed -i \
		-e 's:from botocore[.]vendored import:import:' \
		-e 's:from botocore[.]vendored[.]:from :' \
		{} + || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# rely on bundled six
		tests/functional/test_six_imports.py::test_no_bare_six_imports
		tests/functional/test_six_threading.py::test_six_thread_safety
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests/{functional,unit}
}
