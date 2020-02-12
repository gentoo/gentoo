# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Tools for testing processes"
HOMEPAGE="https://github.com/ionelmc/python-process-tests https://pypi.org/project/process-tests/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# There are no tests at all, under TODO
# see https://pypi.org/project/process-tests/2.0.2/
RESTRICT="test"

DOCS=( README.rst )
