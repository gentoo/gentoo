# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A Python 3 client for the beanstalkd work queue"
HOMEPAGE="https://greenstalk.readthedocs.io/ https://github.com/justinmayhew/greenstalk"
SRC_URI="https://github.com/justinmayhew/greenstalk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		app-misc/beanstalkd
	)
"

distutils_enable_tests pytest

python_test() {
	pytest -vv tests.py || die
}
