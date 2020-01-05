# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="A Python 3 client for the beanstalkd work queue"
HOMEPAGE="https://greenstalk.readthedocs.io/ https://github.com/mayhewj/greenstalk"
SRC_URI="https://github.com/mayhewj/greenstalk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		app-misc/beanstalkd
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	pytest -v tests.py || die
}
