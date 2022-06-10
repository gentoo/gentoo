# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Python library to sort collections and containers"
HOMEPAGE="
	https://www.grantjenks.com/docs/sortedcontainers/
	https://github.com/grantjenks/python-sortedcontainers/
	https://pypi.org/project/sortedcontainers/
"
SRC_URI="
	https://github.com/grantjenks/python-sortedcontainers/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_tests pytest

python_test() {
	epytest --ignore docs/conf.py
}
