# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Adds support for tests during installation of setup.py files"
HOMEPAGE="https://pypi.python.org/pypi/pytest-runner https://bitbucket.org/pytest-dev/pytest-runner"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
SLOT="0"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	"
RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

# Test not included
RESTRICT="test"

python_compile_all() {
	# The build by rst2html.py makes non fatal errors building index.rst
	if use doc; then
		rst2html.py docs/history.rst > docs/history.html
		rst2html.py docs/index.rst > docs/index.html
	fi
}

python_test() {
	esetup.py pytest
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
