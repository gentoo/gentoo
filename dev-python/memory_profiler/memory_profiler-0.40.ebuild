# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A module for monitoring memory usage of a python program"
HOMEPAGE="http://pypi.python.org/pypi/memory_profiler https://github.com/fabianp/memory_profiler"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${EPYTHON} -m memory_profiler test/test_func.py || die
	${EPYTHON} -m memory_profiler test/test_loop.py || die
	${EPYTHON} -m memory_profiler test/test_as.py || die
	${EPYTHON} -m memory_profiler test/test_global.py || die
	${EPYTHON} -m memory_profiler test/test_precision_command_line.py || die
	${EPYTHON} test/test_import.py || die
	${EPYTHON} test/test_memory_usage.py || die
	${EPYTHON} test/test_precision_import.py || die
}
