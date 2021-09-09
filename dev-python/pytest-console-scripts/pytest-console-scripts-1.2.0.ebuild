# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pytest plugin for testing console scripts"
HOMEPAGE="https://github.com/kvas-it/pytest-console-scripts"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest

python_prepare_all() {
	# allow newer setuptools_scm
	sed -i -e 's/setuptools_scm<6/setuptools_scm/g' setup.py || die

	distutils-r1_python_prepare_all
}
