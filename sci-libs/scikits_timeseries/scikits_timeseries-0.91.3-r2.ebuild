# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="SciPy module for manipulating, reporting, and plotting time series"
HOMEPAGE="http://pytseries.sourceforge.net/index.html"
SRC_URI="
	mirror://sourceforge/pytseries/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/pytseries/${MY_P}-html_docs.zip )"

LICENSE="BSD eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/scikits[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}

python_install() {
	distutils-r1_python_install
	rm "${D}"$(python_get_sitedir)/scikits/__init__.py || die
}

python_install_all() {
	use doc && HTMLDOCS=( "${WORKDIR}/html" )
	distutils-r1_python_install_all
}
