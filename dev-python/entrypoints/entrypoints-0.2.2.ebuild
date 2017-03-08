# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Discover and load entry points from installed packages"
HOMEPAGE="https://github.com/takluyver/entrypoints"
SRC_URI="https://github.com//takluyver/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	$(python_gen_cond_dep '>=dev-python/configparser-3.5.0[${PYTHON_USEDEP}]' 'python2*')
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/python-pathlib[${PYTHON_USEDEP}]
	)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"

PATCHES=(
	"${FILESDIR}/${P}"-setup.py.patch
	"${FILESDIR}/${PN}"-0.2.1-init.py.patch
)

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die
	fi

	distutils-r1_python_prepare_all

	mv "${WORKDIR}/${P}"/entrypoints.py "${WORKDIR}/${P}/${PN}/" || die
}

python_compile_all() {
	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	py.test || die
}
