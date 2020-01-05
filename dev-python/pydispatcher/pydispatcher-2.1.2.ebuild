# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_P="PyPyDispatcher-${PV}"
DESCRIPTION="Multi-producer-multi-consumer signal dispatching mechanism"
HOMEPAGE="https://github.com/scrapy/pypydispatcher https://pypi.org/project/PyPyDispatcher/"
SRC_URI="mirror://pypi/${MY_P::1}/${MY_P%-*}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S=${WORKDIR}/${MY_P}

python_compile_all() {
	if use doc; then
		cd docs/pydoc || die
		"${EPYTHON}" builddocs.py || die
	fi
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/pydoc/. )
	distutils-r1_python_install_all
}
