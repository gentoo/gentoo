# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="Simple DNS resolver for asyncio"
HOMEPAGE="https://github.com/saghul/aiodns/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Tests fail with network-sandbox, since they try to resolve google.com
RESTRICT="test"

RDEPEND="dev-python/pycares[${PYTHON_USEDEP}]
	python_targets_python2_7? (
		dev-python/trollius[python_targets_python2_7]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON:-python}" tests.py || die
}
