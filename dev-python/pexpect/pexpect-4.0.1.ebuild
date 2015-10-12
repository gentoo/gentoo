# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python module for spawning child applications and responding to expected patterns"
HOMEPAGE="
	http://pexpect.sourceforge.net/
	https://pypi.python.org/pypi/pexpect/
	https://github.com/pexpect/pexpect/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples test"

RDEPEND=">=dev-python/ptyprocess-0.5[${PYTHON_USEDEP}]"
DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# tests failing
	# https://github.com/pexpect/pexpect/issues/282
	# https://github.com/pexpect/pexpect/issues/283
	# https://github.com/pexpect/pexpect/issues/284
	rm tests/test_maxcanon.py tests/test_async.py || die
	touch .coveragerc || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
