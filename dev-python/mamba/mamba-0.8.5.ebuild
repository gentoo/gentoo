# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="The definitive testing tool for Python. Born under the banner of Behavior Driven Development"
HOMEPAGE="http://nestorsalceda.github.io/mamba"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? (
		~dev-python/doublex-expects-0.7.0_rc1[${PYTHON_USEDEP}]
		~dev-python/expects-0.8.0_rc2[${PYTHON_USEDEP}]
		~dev-python/mock-1.0.1[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	~dev-python/clint-0.3.1[${PYTHON_USEDEP}]
	~dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	~dev-python/watchdog-0.8.1[${PYTHON_USEDEP}]
"

python_test() {
	"${PYTHON}" -m mamba.cli || die "Tests failed under ${EPYTHON}"
}
