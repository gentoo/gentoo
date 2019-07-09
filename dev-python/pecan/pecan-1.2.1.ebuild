# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_5 python3_6 )

inherit distutils-r1

DESCRIPTION="A WSGI object-dispatching web framework,  lean, fast, with few dependencies."
HOMEPAGE="https://pypi.org/project/pecan/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/simplejson-2.1.1[${PYTHON_USEDEP}]
	virtual/python-singledispatch[${PYTHON_USEDEP}]
	dev-python/ordereddict[$(python_gen_usedep 'python2_7')]
	>=dev-python/webob-1.4[${PYTHON_USEDEP}]
	>=dev-python/mako-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/webtest-1.3.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/logutils-0.3.0[${PYTHON_USEDEP}]"
