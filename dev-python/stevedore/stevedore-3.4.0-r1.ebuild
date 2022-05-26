# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="
	https://opendev.org/openstack/stevedore/
	https://github.com/openstack/stevedore/
	https://pypi.org/project/stevedore/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
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

	# Known bug in tests
	# https://bugs.launchpad.net/python-stevedore/+bug/1966040
	sed -i -e 's:test_extras:_&:' stevedore/tests/test_extension.py || die

	# Also known problem, inside venv
	sed -i -e 's:test_disable_caching_file:_&:' \
		stevedore/tests/test_cache.py || die

	distutils-r1_python_prepare_all
}
