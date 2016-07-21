# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="JSON-RPC transport implementation for python"
HOMEPAGE="https://github.com/pavlov99/json-rpc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	cat > jsonrpc/six.py <<- EOF
	from __future__ import absolute_import
	from six import *
	EOF
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
