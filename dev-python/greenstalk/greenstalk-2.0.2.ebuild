# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python 3 client for the beanstalkd work queue"
HOMEPAGE="
	https://greenstalk.readthedocs.io/
	https://github.com/justinmayhew/greenstalk/
	https://pypi.org/project/greenstalk/
"
SRC_URI="
	https://github.com/justinmayhew/greenstalk/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		app-misc/beanstalkd
	)
"

distutils_enable_tests pytest

python_test() {
	epytest tests.py
}
