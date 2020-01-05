# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="https://pypi.org/project/sqlalchemy-migrate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="doc"

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-issuetracker[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/sqlalchemy-0.7.8[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-0.9.5[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
		dev-python/python-sqlparse[${PYTHON_USEDEP}]
		>=dev-python/tempita-0.4[${PYTHON_USEDEP}]"
# Testsuite requires a missing dep and errors with poor report output

python_prepare_all() {
	# Prevent d'loading during the doc build via sphinx.ext.intersphinx
	sed -e "s: 'sphinx.ext.intersphinx',::" -i doc/source/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		einfo ""; einfo "The build seeks to import modules from an installed state of the package"
		einfo "simply ignore all warnings / errors of failure to import module migrate.<module>"; einfo ""
		emake -C doc/source html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/_build/html/. )
	distutils-r1_python_install_all
}
