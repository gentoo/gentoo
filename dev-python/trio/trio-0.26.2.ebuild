# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python library for async concurrency and I/O"
HOMEPAGE="
	https://github.com/python-trio/trio/
	https://pypi.org/project/trio/
"
SRC_URI="
	https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/attrs-23.2.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.2.1[${PYTHON_USEDEP}]
	' 3.10)
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.3.0[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/astor-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.6[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# Bug https://bugs.gentoo.org/916756
# distutils_enable_sphinx docs/source \
# 	dev-python/immutables \
# 	dev-python/sphinxcontrib-trio \
# 	dev-python/sphinx-rtd-theme \
# 	dev-python/towncrier

python_test() {
	local EPYTEST_DESELECT=(
		# Times out on slower arches (ia64 in this case)
		# https://github.com/python-trio/trio/issues/1753
		tests/test_unix_pipes.py::test_close_at_bad_time_for_send_all
		# requires ruff
		_tests/tools/test_gen_exports.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf trio || die
	epytest -p trio._tests.pytest_plugin \
		-m "not redistributors_should_skip" \
		--pyargs trio \
		--skip-optional-imports
}
