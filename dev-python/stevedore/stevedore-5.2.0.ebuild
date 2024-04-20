# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="
	https://opendev.org/openstack/stevedore/
	https://github.com/openstack/stevedore/
	https://pypi.org/project/stevedore/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx 'doc/source' \
	'>=dev-python/openstackdocstheme-1.18.1' \
	'>=dev-python/reno-2.5.0' \
	'>=dev-python/sphinx-2.0.0'

python_prepare_all() {
	# Delete spurious data in requirements.txt
	sed -e '/^pbr/d' -i requirements.txt || die

	# Also known problem, inside venv
	sed -i -e 's:test_disable_caching_file:_&:' \
		stevedore/tests/test_cache.py || die

	distutils-r1_python_prepare_all
}
