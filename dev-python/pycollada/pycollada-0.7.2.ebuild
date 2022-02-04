# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python library for reading and writing COLLADA documents"
HOMEPAGE="https://pycollada.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.2[${PYTHON_USEDEP}]
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
