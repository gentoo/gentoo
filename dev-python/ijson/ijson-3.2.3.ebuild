# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="
	https://github.com/ICRAR/ijson/
	https://pypi.org/project/ijson/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	dev-libs/yajl
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

export IJSON_BUILD_YAJL2C=1

python_test() {
	rm -rf ijson || die
	epytest
}
