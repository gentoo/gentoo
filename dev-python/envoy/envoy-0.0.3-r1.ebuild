# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Simple API for running external processes"
HOMEPAGE="https://github.com/kennethreitz/envoy https://pypi.python.org/pypi/envoy"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RESTRICT="test"

python_test() {
	# These unit tests fail, see the following issue:
	# https://github.com/kennethreitz/envoy/issues/58
	"${PYTHON}" test_envoy.py || die
}
