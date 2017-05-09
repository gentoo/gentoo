# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="repoze.who is an identification and authentication framework for WSGI"
HOMEPAGE="http://www.repoze.org"
SRC_URI="mirror://pypi/${PN:0:1}/repoze.who/repoze.who-${PV}.tar.gz"
S="${WORKDIR}/repoze.who-${PV}"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
