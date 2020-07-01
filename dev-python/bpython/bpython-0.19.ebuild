# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="https://www.bpython-interpreter.org/ https://github.com/bpython/bpython https://pypi.org/project/bpython/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/curtsies-0.2.11[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	"
# sphinx is used implicitly to build manpages
BDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

DOCS=( AUTHORS CHANGELOG sample.theme light.theme )

distutils_enable_sphinx doc/sphinx/source --no-autodoc
distutils_enable_tests unittest

src_prepare() {
	sed -e 's:test_exec_dunder_file:_&:' \
		-e 's:test_exec_nonascii_file_linenums:_&:' \
		-i bpython/test/test_args.py || die
	distutils-r1_src_prepare
}
