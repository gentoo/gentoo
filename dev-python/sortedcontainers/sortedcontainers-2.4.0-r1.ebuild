# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Python library to sort collections and containers"
HOMEPAGE="
	https://grantjenks.com/docs/sortedcontainers/
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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	epytest --ignore docs/conf.py
}
