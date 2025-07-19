# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python library for reading and writing COLLADA documents"
HOMEPAGE="
	https://pycollada.readthedocs.io/
	https://github.com/pycollada/pycollada/
	https://pypi.org/project/pycollada/
"
SRC_URI="
	https://github.com/pycollada/pycollada/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS.md COPYING README.markdown )

distutils_enable_sphinx docs
distutils_enable_tests unittest

python_install_all() {
	if use examples ; then
		insinto /usr/share/${PF}/
		doins -r examples
	fi

	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install

	# ensure data files for tests are getting installed too
	python_moduleinto collada/tests/
	python_domodule collada/tests/data
}
