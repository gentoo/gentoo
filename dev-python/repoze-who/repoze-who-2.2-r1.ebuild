# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="repoze.who is an identification and authentication framework for WSGI"
HOMEPAGE="http://www.repoze.org"
SRC_URI="mirror://pypi/${PN:0:1}/repoze.who/repoze.who-${PV}.tar.gz"
S="${WORKDIR}/repoze.who-${PV}"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/namespace-repoze[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}

python_install() {
	distutils-r1_python_install

	# install __init__.py files for sub-namespaces
	python_moduleinto repoze.who
	python_domodule repoze/who/__init__.py

	python_moduleinto repoze.who.plugins
	python_domodule repoze/who/plugins/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
