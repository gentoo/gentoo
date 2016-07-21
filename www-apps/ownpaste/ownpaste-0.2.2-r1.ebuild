# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

HG_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	HG_ECLASS="mercurial"
	EHG_REPO_URI="http://hg.rafaelmartins.eng.br/ownpaste/"
fi

inherit distutils-r1 ${HG_ECLASS}

DESCRIPTION="Private pastebin (server-side implementation)"
HOMEPAGE="http://ownpaste.rtfd.org/ https://pypi.python.org/pypi/ownpaste"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/flask-script-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-0.15[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.6[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.8[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.7.2[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
		einfo 'building documentation'
		emake -C docs html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
