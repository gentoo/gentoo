# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_6 )

inherit distutils-r1

DESCRIPTION="A JavaScript minifier written in Python"
HOMEPAGE="https://slimit.readthedocs.io/en/latest/"
SRC_URI="https://github.com/rspivak/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/ply:=[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-fix-python3.patch" )

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile

	rm "${BUILD_DIR}"/lib/slimit/*tab.py || die

	# Regenerate yacctab.py and lextab.py files to avoid warnings whenever
	# the module is imported. See https://github.com/rspivak/slimit/issues/97
	# for details
	"${EPYTHON}" -B -c 'import slimit;slimit.minify("")' || die
}

python_test() {
	pytest -vv "${BUILD_DIR}" || die "Tests failed with ${EPYTHON}"
}
