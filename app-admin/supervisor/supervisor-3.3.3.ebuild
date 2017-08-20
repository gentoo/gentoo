# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )	# py2 only
# xml.etree.ElementTree module required.
PYTHON_REQ_USE="xml"

inherit distutils-r1

MY_PV="${PV/_beta/b}"

DESCRIPTION="A system for controlling process state under UNIX"
HOMEPAGE="http://supervisord.org/ https://pypi.python.org/pypi/supervisor"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="repoze ZPL BSD HPND GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/meld3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${MY_PV}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	newinitd "${FILESDIR}/init.d-r1" supervisord
	newconfd "${FILESDIR}/conf.d" supervisord
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
