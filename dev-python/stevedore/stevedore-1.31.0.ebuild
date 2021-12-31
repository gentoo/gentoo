# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=rdepend
# entry_points is added via setup.cfg as just [entry_points]
_DISTUTILS_SETUPTOOLS_WARNED=1

inherit distutils-r1

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="https://github.com/openstack/stevedore https://pypi.org/project/stevedore/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
BDEPEND="
	${CDEPEND}
	test? (
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
distutils_enable_sphinx 'doc/source' \
	'>=dev-python/openstackdocstheme-1.18.1' \
	'>=dev-python/reno-2.5.0' \
	'>=dev-python/sphinx-2.0.0'

python_prepare_all() {
	# Delete spurious data in requirements.txt
	sed -e '/^pbr/d' -i requirements.txt || die
	distutils-r1_python_prepare_all
}
