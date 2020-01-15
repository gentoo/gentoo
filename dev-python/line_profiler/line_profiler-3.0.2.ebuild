# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Line-by-line profiler"
HOMEPAGE="https://github.com/pyutils/line_profiler"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]"

RDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/ubelt[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	# tests fail if not already installed
	# to fix this, source files should be in PYTHONPATH
	# also, tests call kernprof, so we have to move that
	# back to the source files and make it executable
	cp "${BUILD_DIR}/lib/kernprof.py" "${WORKDIR}/${P}/kernprof" || die
	chmod +x "${WORKDIR}/${P}/kernprof" || die
	cp "${BUILD_DIR}/lib/${PN}" -r "${WORKDIR}/${P}" || die
	PYTHONPATH="${WORKDIR}/${P}"
	PATH="${PATH}:${WORKDIR}/${P}"

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
