# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Manuel lets you build tested documentation"
HOMEPAGE="https://github.com/benji-york/manuel/ https://pypi.org/project/manuel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Required to run tests
DISTUTILS_IN_SOURCE_BUILD=1

#DOCS=( CHANGES.rst )

#PATCHES=( "${FILESDIR}"/${P}-rm_zope_test.patch )

#python_test() {
#	PYTHONPATH=src/:${PYTHONPATH} esetup.py test
#}
