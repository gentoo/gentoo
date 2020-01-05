# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python module for making simple text/console-mode user interfaces"
HOMEPAGE="http://pythondialog.sourceforge.net/ https://pypi.org/project/python2-pythondialog/"
SRC_URI="mirror://pypi/${PN:0:1}/python2-${PN}/python2-${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="python-2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="doc examples"

RDEPEND="dev-util/dialog"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/python2-${P}"

python_prepare_all() {
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use examples && dodoc -r examples
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
}
