# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python 3 bindings for libfuse 3 with asynchronous API"
HOMEPAGE="https://github.com/libfuse/pyfuse3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CDEPEND="
	sys-fs/fuse:3
"

RDEPEND="
	dev-python/trio[${PYTHON_USEDEP}]
	${CDEPEND}
"

DEPEND="
	${CDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/pytest-trio[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

python_prepare_all() {
	python_setup
	# Shipped pre-generated .pyx do not work with Python 3.10.
	esetup.py build_cython
	distutils-r1_python_prepare_all
}
