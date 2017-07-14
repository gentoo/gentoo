# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="A Python module for making simple text/console-mode user interfaces"
HOMEPAGE="http://pythondialog.sourceforge.net/ https://pypi.python.org/pypi/python2-pythondialog"
SRC_URI="mirror://pypi/${PN:0:1}/python2-${PN}/python2-${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="python-2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="doc examples"

RDEPEND="dev-util/dialog"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/python2-${P}"

python_prepare() {
	if python_is_python3; then
		2to3 -w --no-diffs setup.py || die "could not convert to Python 3"
	fi
}

python_prepare_all() {
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
}
