# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python library to solve linear games over symmetric cones"
HOMEPAGE="https://michael.orlitzky.com/code/dunshire/"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.gz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-python/cvxopt[${PYTHON_USEDEP}]"
DOCS=( doc/README.rst )

distutils_enable_sphinx doc/source
distutils_enable_tests setup.py

python_test() {
	esetup.py test
}
