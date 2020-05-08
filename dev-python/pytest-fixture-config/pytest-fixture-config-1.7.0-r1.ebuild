# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Virtualenv fixture for py.test"
HOMEPAGE="https://github.com/manahl/pytest-plugins https://pypi.org/project/pytest-fixture-config/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
# block pytest plugins that will be broken by the upgrade
RDEPEND+="
	!<dev-python/pytest-virtualenv-1.7.0-r1[python_targets_python2_7(-)]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-git[${PYTHON_USEDEP}]
	test? ( dev-python/six[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
