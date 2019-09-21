# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests fail with PyPy: https://github.com/wbolster/plyvel/issues/38
PYTHON_COMPAT=( pypy3 python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="Python interface to LevelDB"
HOMEPAGE="https://github.com/wbolster/plyvel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-libs/leveldb-1.20:="
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_compile() {
	# https://wiki.gentoo.org/wiki/Project:Python/Strict_aliasing
	python_is_python3 || local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		sphinx-build doc doc/_build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	# We need to copy the extension to the package folder
	local ext="$(ls "${BUILD_DIR}/lib/${PN}/"*.so | head -n1 || die)"
	ln -s "${ext}" "${PN}" || die
	pytest -vv || die "tests failed with ${EPYTHON}"
	rm "${PN}/$(basename "${ext}")" || die
}
