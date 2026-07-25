# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="
	https://opendev.org/openstack/stevedore/
	https://github.com/openstack/stevedore/
	https://pypi.org/project/stevedore/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ~ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx 'doc/source' \
	'>=dev-python/openstackdocstheme-1.18.1' \
	'>=dev-python/reno-2.5.0' \
	'>=dev-python/sphinx-2.0.0'

python_test() {
	local EPYTEST_DESELECT=(
		# also fails in venv
		stevedore/tests/test_cache.py::TestCache::test_disable_caching_file
	)
	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/sphinx[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			stevedore/tests/test_sphinxext.py
		)
	fi

	epytest
}
