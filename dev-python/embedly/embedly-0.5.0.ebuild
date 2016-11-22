# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

MY_PN="Embedly"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Library for Embedly"
HOMEPAGE="https://github.com/embedly/embedly-python/ https://pypi.python.org/pypi/Embedly"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
# Testsuite relies upon connection to various sites on the net
