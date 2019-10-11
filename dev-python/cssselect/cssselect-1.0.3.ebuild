# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit distutils-r1

DESCRIPTION="parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="https://cssselect.readthedocs.io/en/latest/
	https://pypi.org/project/cssselect/
	https://github.com/scrapy/cssselect"
SRC_URI="https://github.com/scrapy/cssselect/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/lxml[${PYTHON_USEDEP}] )"

RDEPEND=""

python_prepare_all() {
	# prevent non essential d'load of files in doc build
	sed -e 's:intersphinx_:#&:' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		esetup.py build_sphinx
	fi
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
